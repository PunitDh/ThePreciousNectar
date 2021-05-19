class CartsController < ApplicationController
    before_action :authenticate_user!
    rescue_from RuntimeError, with: :unauthorised
    rescue_from Pundit::NotAuthorizedError, with: :unauthorised

    def unauthorised
        flash[:alert] = "You're not allowed! Go away!"
        redirect_to root_path
    end

    def show
    end

    def add_to_cart
        cartlisting = CartListing.new(cartparams)
        # raise params.inspect
        # Verify and validate whether the cart actually belongs to the user
        if (current_user.cart.id == params[:cart_id].to_i)
            cartlisting.cart_id = params[:cart_id].to_i

            cartlisting.listing_id = params[:listing_id].to_i # if (Listing.find_by(id: params[:listing_id].to_i))

            existing = CartListing.where(cart_id: current_user.cart.id, listing_id: cartlisting.listing_id)
            if existing.length > 0
                existing.first.quantity += 1
                existing.first.save
            else
                cartlisting.quantity = 1
                if cartlisting.save
                    # p "Item Added to cart"
                    flash[:notice] = "Item added to Cart!"
                else
                    flash[:notice] = "Failed to add to Cart!"
                end
            end
        end
        # redirect_to listings_index_path
        
    end

    def show
        @cartlisting = CartListing.where(cart_id: current_user.cart.id)
    end

    private
        def cartparams
            params.permit(:cart_id, :listing_id)
        end
end