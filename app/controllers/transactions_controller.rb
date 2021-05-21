class TransactionsController < ApplicationController
    before_action :authenticate_user!, except: [:webhook]
    skip_before_action :verify_authenticity_token, only: [:webhook]
    before_action :all_cartlistings, only: [:index, :success]
    protect_from_forgery except: :webhook

    def webhook
        payload = request.body.read
        event = nil
        
        begin
            event = Stripe::Webhook.construct_event(
            payload, sig_header, ENV["STRIPE_WEBHOOK_KEY"]
            )
        rescue JSON::ParserError => e
            # Invalid payload
            status 400
            return
        end

        rescue Stripe::SignatureVerificationError => e
            # Invalid signature
            puts "Signature error"
            p e
            return
        end
        
        # Handle the event
        case event.type
        when 'payment_intent.succeeded'
            payment_intent = event.data.object # contains a Stripe::PaymentIntent
            
            @cartlistings.each do |cartlisting|
                # Create a new transaction based on whatever is in the cart
                transaction = Transaction.new
                listing = Listing.find(cartlisting.listing_id)

                # Set transaction parameters based on the user's current cart
                seller = listing.user
                transaction.listing_id = listing.id
                transaction.buyer_id = current_user.id
                transaction.seller_id = seller.id
                transaction.quantity = cartlisting.quantity
                transaction.message = params[:message]

                if transaction.save
                    # Flash a message to show the user the transaction was successful
                    flash[:success] = "Your order was successfully placed!"

                    # Clear the cart when the transaction has been completed
                    CartListing.where(cart_id: current_user.cart.id).destroy_all
                    redirect_to :success
                else
                    # Display an error message if transaction was unsuccessful
                    flash[:alert] = "There was an error in placing your order."
                    redirect_to :cancel
                end
            end
            
        when 'payment_method.attached'
            payment_method = event.data.object # contains a Stripe::PaymentMethod
            # Then define and call a method to handle the successful attachment of a PaymentMethod.
            # handle_payment_method_attached(payment_method)
        # ... handle other event types
        else
            puts "Unhandled event type: #{event.type}"
        end
        
        status 200



        # payment_id = params[:data][:object][:payment_intent]
        # payment = Stripe::PaymentIntent.retrieve(payment_id)
        # user_id = payment.metadata.user_id
        # p "User id " + user_id
        
        # # Once the payment has gone through, the user gets redirected to the success page. This is where the transaction takes place
        # @cartlistings = current_user.cart.cart_listings
        # @cartlistings.each do |cartlisting|
        #     # Create a new transaction based on whatever is in the cart
        #     transaction = Transaction.new
        #     listing = Listing.find(cartlisting.listing_id)

        #     # Set transaction parameters based on the user's current cart
        #     seller = listing.user
        #     transaction.listing_id = listing.id
        #     transaction.buyer_id = current_user.id
        #     transaction.seller_id = seller.id
        #     transaction.quantity = cartlisting.quantity
        #     transaction.message = params[:message]

        #     if transaction.save
        #         # Flash a message to show the user the transaction was successful
        #         flash[:success] = "Your order was successfully placed!"
        #         # Clear the cart when the transaction has been completed
        #         # CartListing.where(cart_id: current_user.cart.id).destroy_all
        #         # redirect_to :success
        #     else
        #         # Display an error message if transaction was unsuccessful
        #         flash[:alert] = "There was an error in placing your order."
        #         # redirect_to :cancel
        #     end
        # end
    end    

    def index
        # @cartlistings
    end

    def sales
        @transactions = Transaction.all.where(seller: current_user).order("created_at DESC")
    end

    def purchases
        @transactions = Transaction.all.where(buyer: current_user).order("created_at DESC")
    end

    def success
        # Pass the cart one last time to the views page so that an Order Summary can be displayed
        @cartlistings
    end

    def cancel
        flash[:alert] = "There was an error in placing your order."
    end

    private
        def all_cartlistings
            @cartlistings = current_user.cart.cart_listings
        end

        def clear_cart
            # Clear the cart of all items
            CartListing.where(cart_id: current_user.cart.id).destroy_all
        end
end