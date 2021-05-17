class ListingsController < ApplicationController
    before_action :authenticate_user!

    def index
        @listings = Listing.all
    end

    def show
        @listing = Listing.find(params[:id])
        render 'listings/show'
    end

    def new
        @listing = Listing.new
    end

    def create
        @listing = Listing.new(listing_params)
        @listing.user_id = current_user.id
        @listing.category_id = params[:listing][:category_id].to_i
        @listing.region_id = params[:listing][:region_id].to_i
        @listing.vintage = params[:listing][:vintage]
        @listing.price = params[:listing][:price].to_i * 100
        p @listing
        # puts @listing.user_id, @listing.name, @listing.vintage, @listing.price, @listing.category_id, @listing.region_id, @listing.description
        @listing.save
        redirect_to listing_show_path(@listing.id)
    end

    private
        def listing_params
            params.require(:listing).permit(:name, :vintage, :variety_id, :region_id, :description, :price, :image)
        end
end
