class CartsController < ApplicationController
    before_action :authenticate_user!
    
    # rescue_from RuntimeError, with: :unauthorised
    # rescue_from Pundit::NotAuthorizedError, with: :unauthorised

    # def unauthorised
    #     flash[:alert] = "Unauthorized access blocked."
    #     redirect_to root_path
    # end

    def index
        @cartlistings = current_user.cart.cart_listings

        # raise params.inspect
        # Check if there is anything in the cart
        if @cartlistings.length > 0
            
            # Create a blank array to store all items in cart
            line_items = []
            
            # Pass all line items to Stripe to modify the checkout page
            @cartlistings.each do |cartlisting|
                listing = Listing.find(cartlisting.listing_id)
                line_items << {
                    price: listing.stripe_price_id,

                    # These are no longer required as stripe_price_id takes care of everything
                    # name: listing.name,
                    # amount: listing.price,
                    # currency: "aud",
                    
                    quantity: cartlisting.quantity
                }
            end

            # Create Stripe session ready to go when checkout button is clicked
            @session = Stripe::Checkout::Session.create({
                customer: current_user.stripe_customer_id,
                payment_method_types: ['card'],
                line_items: line_items,
                payment_intent_data: {
                    metadata: {
                        user_id: current_user.stripe_customer_id
                    }
                },
                mode: 'payment',
                success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
                cancel_url: checkout_cancel_url
            })
            @session_id = @session.id
        end
    end

    def update
        # Verify that the user is signed in to modify this cart
        @cartlisting = CartListing.find(params[:cartlisting_id])
        if current_user.cart.id == @cartlisting.cart_id
            @cartlisting.quantity = params[:quantity].to_i
            saverecord(@cartlisting, "Cart updated!", "Failed to update cart!")
        end
        redirect_to request.referrer
    end

    def add
        cartlisting = CartListing.new
        
        # Verify whether the cart actually belongs to the user
        if (current_user.cart.id == params[:cart_id].to_i)
            cartlisting.cart_id = params[:cart_id].to_i
            cartlisting.listing_id = params[:listing_id].to_i # if (Listing.find_by(id: params[:listing_id].to_i))

            existing = CartListing.where(cart_id: current_user.cart.id, listing_id: cartlisting.listing_id)
            if existing.length > 0
                existing.first.quantity += 1
                saverecord(existing.first)
            else
                cartlisting.quantity = 1
                saverecord(cartlisting)
            end
        end
        redirect_to request.referrer
    end

    def delete
        if CartListing.destroy(CartListing.find(params[:cartlisting_id]).id)
            flash[:notice] = "Cart item deleted!"
        else
            flash[:alert] = "Failed to delete cart item"
        end
        redirect_to request.referrer
    end

    private
        def saverecord(current_record, notice="Item added to cart!", alert="Failed to add to cart!")
            if current_record.save
                flash[:notice] = notice
            else
                flash[:alert] = alert
            end
        end
end