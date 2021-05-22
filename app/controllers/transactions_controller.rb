class TransactionsController < ApplicationController
    before_action :authenticate_user!, except: [:webhook]
    skip_before_action :verify_authenticity_token, only: [:webhook]
    before_action :all_cartlistings, only: [:index, :success]
    protect_from_forgery except: :webhook

    def webhook
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        event = nil
        
        begin
            event = Stripe::Webhook.construct_event(
            payload, sig_header, ENV["STRIPE_WEBHOOK_KEY"]
            )
        rescue JSON::ParserError => e
            # Invalid payload
            status 400
            return
        rescue Stripe::SignatureVerificationError => e
            # Invalid signature
            puts "Signature error"
            p e
            return
        end
        
        # Handle the event
        case event.type
        # when 'charge.succeeded'
        
        when 'checkout.session.completed'
            session = event.data.object # contains a Stripe::PaymentIntent
            customer_stripe_id = event.data.object.customer
            customer = User.find_by(stripe_customer_id: customer_stripe_id)
            customer_id = customer.id
            
            print "CUSTOMER STRIPE ID: "
            print customer_stripe_id
            puts ""
            print "CUSTOMER: "
            print customer
            puts ""
            print "CUSTOMER ID: "
            print customer_id

            session_with_expand = Stripe::Checkout::Session.retrieve({id: session.id, expand: ["line_items"]})
            session_with_expand.line_items.data.each do |line_item|
                listing = Listing.find_by(stripe_product_id: line_item.price.product)
                
                puts listing.id
                puts line_item.quantity
                seller = listing.user
                transaction = Transaction.new
                transaction.listing_id = listing.id
                transaction.buyer_id = customer_id
                transaction.seller_id = seller.id
                transaction.quantity = line_item.quantity
                # transaction.message = params[:message] # Needs

                if transaction.save
                    flash[:notice] = "Your order was successfully placed."
                end
            end

            # Flash a message to show the user the transaction was successful
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
            #         # Clear the cart when the transaction has been completed
            #         CartListing.where(cart_id: current_user.cart.id).destroy_all
            #     end
            # end
            CartListing.where(cart_id: customer.cart.id).destroy_all

            
        else
            # Display an error message if transaction was unsuccessful
            flash[:alert] = "There was an error in placing your order."
            puts "Unhandled event type: #{event.type}"
        end
        
        render json: {message: 'success'}
        # status 200
    end

    # def webhook
    #     # pp params
    #     # payment_id = params[:data][:object][:payment_intent]
    #     # payment = Stripe::PaymentIntent.retrieve(payment_id)
    #     # p payment.metadata.user_id
    #     # p "WEBHOOK HAS BEEN RECEIVED"
        

    #     # begin
            
    #     # rescue ActiveRecord::RecordNotFound => e
    #     # end

    #     # raise params[:data][:object][:metadata]
    #     print "USER: "
    #     user = params[:data][:object][:metadata][:user_id]
    #     @cartlistings = User.find(user).cart.cart_listings

    #     # # Once the payment has gone through, the transaction takes place
    #     # @cartlistings.each do |cartlisting|
    #     #     # Create a new transaction based on whatever is in the cart
    #     #     transaction = Transaction.new
    #     #     listing = Listing.find(cartlisting.listing_id)

    #     #     # Set transaction parameters based on the user's current cart
    #     #     seller = listing.user
    #     #     transaction.listing_id = listing.id
    #     #     transaction.buyer_id = current_user.id
    #     #     transaction.seller_id = seller.id
    #     #     transaction.quantity = cartlisting.quantity
    #     #     transaction.message = params[:message]

    #     #     if transaction.save
    #     #         # Flash a message to show the user the transaction was successful
    #     #         flash[:success] = "Your order was successfully placed!"
    #     #         # Clear the cart when the transaction has been completed
    #     #         CartListing.where(cart_id: current_user.cart.id).destroy_all
    #     #         redirect_to :success
    #     #     else
    #     #         # Display an error message if transaction was unsuccessful
    #     #         flash[:alert] = "There was an error in placing your order."
    #     #         redirect_to :cancel
    #     #     end
    #     # end
    #     redirect_to :process_transaction
    # end

    # def process_transaction

    # end

    def sales
        @transactions = Transaction.all.where(seller: current_user).order("created_at DESC")
    end

    def purchases
        @transactions = Transaction.all.where(buyer: current_user).order("created_at DESC")
    end

    def success
    end

    def cancel
    end

    private
        def all_cartlistings
            @cartlistings = current_user.cart.cart_listings
        end
end