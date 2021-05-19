class ListingsController < ApplicationController
    before_action :authenticate_user!
    before_action :listing_find, only: [:show, :edit, :update, :delete]

    def index
        @listings = Listing.all
    end

    def show
        # render 'listings/show'
    end

    def new
        @listing = Listing.new
    end

    def create
        @listing = Listing.new(listing_params)
        @listing.user_id = current_user.id
        @listing.category_id = Category.find_by(name: params[:listing][:category_id]).id
        @listing.region_id = params[:listing][:region_id].to_i
        @listing.vintage = params[:listing][:vintage]
        @listing.price = params[:listing][:price].to_i * 100
        if @listing.save
            flash[:notice] = "Successfully created listing"
            redirect_to listing_show_path(@listing.id)
        else
            flash[:notice] = "Unable to create listing at this time"
            redirect_to request.referrer
        end
    end

    def edit
        @listing.category_id = Category.find(@listing.category_id).name
        @listing.price /= 100
    end

    def update
        # Authorisation from Pundit
        authorize @listing
        if @listing.update(listing_params)
            flash[:notice] = "Successfully updated listing"
            redirect_to @listing
          else
            flash[:alert] = "Failed to update listing"
            render :edit
        end
    end

    def delete
        if Listing.destroy(@listing.id)
            flash[:notice] = "Listing was successfully deleted"
            redirect_to listings_index_path
        else
            flash[:alert] = "Failed to delete listing"
            redirect_to request.referrer
        end
    end

    def userlistings

    end

    private
        def listing_params
            params.require(:listing).permit(:name, :vintage, :category_id, :region_id, :description, :price, :image)
        end

        def listing_find
            @listing = Listing.find(params[:id])
        end
end
