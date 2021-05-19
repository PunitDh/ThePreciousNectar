class ListingsController < ApplicationController
    before_action :authenticate_user!
    before_action :listing_find, only: [:show, :edit]

    def index
        @listings = Listing.all
    end

    def show
        render 'listings/show'
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
        @listing.save
        redirect_to listing_show_path(@listing.id)
    end

    def edit
    end

    def update
        # Authorisation from Pundit
        @listing = Listing.find(params[:id])
        authorize @listing
        if @listing.update(post_params)
            redirect_to @listing
          else
            render :edit
        end
    end

    private
        def listing_params
            params.require(:listing).permit(:name, :vintage, :category_id, :region_id, :description, :price, :image)
        end

        def listing_find
            @listing = Listing.find(params[:id])
        end
end
