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
        @listing.save
        redirect_to root_path
    end

    private
        def listing_params
            params.fetch(:listing, {}).permit(:name, :image)
        end
end
