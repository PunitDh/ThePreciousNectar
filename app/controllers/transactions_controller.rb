class TransactionsController < ApplicationController
    before_action :authenticate_user!, except: [:webhook]
    skip_before_action :verify_authenticity_token, only: [:webhook]
    protect_from_forgery except: :webhook

    def webhook
        # The webhook functionality to process Stripe payments and complete transactions
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        event = nil
        
        begin
            event = Stripe::Webhook.construct_event(
            payload, sig_header, ENV["STRIPE_WEBHOOK_KEY"]
            )
        rescue JSON::ParserError => e
            # Invalid payload
            # status 400
            head :bad_request
            return
        rescue Stripe::SignatureVerificationError => e
            # Invalid signature
            head :unauthorised
            return
        end
        
        # Handle the event
        case event.type
        when 'charge.succeeded'
            # Blank event type to debug 500 Internal Server errors

        when 'checkout.session.completed'

            session = event.data.object # contains a Stripe::PaymentIntent
            customer_stripe_id = session.customer
            customer = User.find_by(stripe_customer_id: customer_stripe_id)
            session_with_expand = Stripe::Checkout::Session.retrieve({id: session.id, expand: ["line_items"]})
            session_with_expand.line_items.data.each do |line_item|
                
                # Do the transaction - Transfer items from seller to buyer
                listing = Listing.find_by(stripe_product_id: line_item.price.product)
                seller = listing.user
                transaction = Transaction.new
                transaction.listing_id = listing.id
                transaction.buyer_id = customer.id
                transaction.seller_id = seller.id
                transaction.quantity = line_item.quantity

                # Save transaction
                if transaction.save
                    flash[:notice] = "Your order was successfully placed."
                end
            end

            # raise CartListing.where(cart_id: customer.cart.id).inspect
            CartListing.where(cart_id: customer.cart.id).destroy_all
             
        else
            # Display an error message if transaction was unsuccessful
            flash[:alert] = "There was an error in placing your order."
            puts "Unhandled event type: #{event.type}"
        end
        status 200
    end

    def sales
        # Find all purchases depending on whether the current user is a seller
        @transactions = Transaction.all.where(seller: current_user).order("created_at DESC")
    end

    def purchases
        # Find all purchases depending on whether the current user is a buyer
        @transactions = Transaction.all.where(buyer: current_user).order("created_at DESC")
    end

    def success
        # Send information to the success page that needs to be displayed in the order summary
        @session_with_expand = Stripe::Checkout::Session.retrieve( { id: params[:session_id], expand: ["line_items"] })
    end

    def cancel
    end
end