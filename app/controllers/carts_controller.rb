class CartsController < ApplicationController
    before_action :authenticate_user!

    def show
    end

    def add_to_cart
        cartlisting = CartListing.new(cartparams)
        # raise params.inspect
        # Verify and validate whether the cart actually belongs to the user
        if (current_user.cart.id == params[:cart_id].to_i)
            cartlisting.cart_id = params[:cart_id].to_i

            # Validate whether the item actually exists in the database
            cartlisting.listing_id = params[:listing_id].to_i # if (Listing.find_by(id: params[:listing_id].to_i))
            # raise cartlisting
            # p cartlisting
            # Attempt to save the item to the cart
            if cartlisting.save
                p "Item Added to cart"
                flash[:success] = "Item added to Cart!"
            else
                flash[:danger] = "Failed to add to Cart!"
            end
        end
    end

    def show
        p current_user.cart.id
        @cartlisting = CartListing.where(cart_id: current_user.cart.id)
        p @cartlisting
        # @items = Listing.all.each { |listing|  }
    end

    private

        def cartparams
            params.permit(:cart_id, :listing_id)
        end

end