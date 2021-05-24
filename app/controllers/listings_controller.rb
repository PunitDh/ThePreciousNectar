class ListingsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :listing_find, only: [:show, :edit, :update, :delete]

    def index
        @listings = Listing.all
    end

    def show
    end

    def new
        unless current_user.profile.present?
            flash[:alert] = "You must create a seller profile before you can list items for sale."
            redirect_to user_profile_new_path
        else
            @listing = Listing.new
        end
    end

    def create      # Create a new listing
        @listing = Listing.new(listing_params)
        @listing.price = params[:listing][:price].to_i * 100
        @listing.user_id = current_user.id
        respond_to do |format|
            if @listing.save
                format.html { redirect_to listing_path(@listing.id), notice: "Successfully created listing." }
                format.json { render :show, status: :created }
            else
                flash[:alert] = "Unable to create listing at this time."
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @listing.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
        @listing.price /= 100
    end

    def update
        # Authorisation from Pundit
        authorize @listing
        @listing.assign_attributes(listing_params)
        @listing.price = params[:listing][:price].to_i * 100
        respond_to do |format|
            if @listing.save
              format.html { redirect_to listing_path(@listing.id), notice: "Successfully updated listing." }
              format.json { render :show, status: :ok }
            else
              flash[:alert] = "There was an error in updating your listing."
              format.html { render :show, status: :unprocessable_entity }
              format.json { render json: @listing.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy      # Delete listing
        if Listing.destroy(@listing.id)
            flash[:notice] = "Listing was successfully deleted"
            redirect_to listings_path
        else
            flash[:alert] = "Failed to delete listing"
            redirect_to request.referrer
        end
    end

    def all
        @listings = Listing.all.where(user_id: current_user.id)
    end

    private
        def listing_params
            params.require(:listing).permit(:name, :vintage, :category_id, :region_id, :description, :price, :image)
        end

        def listing_find
            @listing = Listing.find(params[:id])
        end
end