class ListingsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :listing_find, only: [:show, :edit, :update, :delete]

    def index
        # Show all listings on website
        @listings = Listing.all
    end

    def show
    end

    def new
        # In order to sell an item, the seller must have a profile. This method redirects
        # the user to the profile creation page where users can create a profile
        unless current_user.profile.present?
            flash[:alert] = "You must create a seller profile before you can list items for sale."
            redirect_to user_profile_new_path
        else
            @listing = Listing.new
            # if params[:q]
            #     @results = GoogleCustomSearchApi.search(params[:q], page: 1)
            # end
        end
    end

    def create      # Create a new listing
        @listing = Listing.new(listing_params)

        # Set price in cents by multiplying by 100
        @listing.price = params[:listing][:price].to_i * 100
        @listing.user_id = current_user.id

        # Save listing
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
        # Divide price by cents to get dollar figure
        @listing.price /= 100
    end

    def update
        # Authorisation from Pundit
        authorize @listing
        @listing.assign_attributes(listing_params)

        # Convert price to cents
        @listing.price = params[:listing][:price].to_i * 100

        # Update listing
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
        # Display all the users' listings
        # raise params.inspect
        @listings = Listing.where(user_id: params[:id])
        pp @listings
    end

    # No longer used
    # def scrape
    #     if params[:q]
    #       page = params[:page] || 1
    #       @results = GoogleCustomSearchApi.search(params[:q],
    #                                               page: page)
    #                                               pp GoogleCustomSearchApi.search(params[:q],
    #                                               page: page)                            
    #     end
    #     render :new
    # end

    private
        def listing_params
            params.require(:listing).permit(:name, :vintage, :category_id, :region_id, :description, :price, :image)
        end

        def listing_find
            @listing = Listing.find(params[:id])
        end
end