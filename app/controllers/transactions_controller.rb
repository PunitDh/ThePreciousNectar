class TransactionsController < ApplicationController
    before_action :authenticate_user!

    def index
        @transactions = Transaction.all
    end

    def success
        # Once the payment has gone through, the user gets redirected to the success page. This is where the transaction takes place
        @cartlistings = current_user.cart.cart_listings
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
                flash.now[:success] = "Your order was successfully placed!"
                
                # Clear the cart when the transaction has been completed
                CartListing.where(cart_id: current_user.cart.id).destroy_all
            else
                # Display an error message if transaction was unsuccessful
                flash.now[:alert] = "There was an error in placing your order."
            end
        end
    end

    def cancel
        # Go to the transaction cancel page
    end
end