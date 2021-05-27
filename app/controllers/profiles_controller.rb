class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :get_profile, only: %i[ show update new ]

    # Basic CRUD controller for user profiles

    def new
        # If a profile already exists, redirect to the profile. Or else create a new one
        if get_profile.present?
            redirect_to user_profile_show_path
        else
            @profile = Profile.new
        end
    end

    def create
        # A method to create a new profile
        @profile = Profile.new(permitted_params)
        @profile.user_id = current_user.id

        respond_to do |format|
            if @profile.save
              format.html { redirect_to user_profile_show_path, notice: "Successfully created profile." }
              format.json { render :show, status: :created }                
            else
              flash[:alert] = "There was an error in creating your profile."
              format.html { render user_profile_new_path, status: :unprocessable_entity }
              format.json { render json: @profile.errors, status: :unprocessable_entity }
            end
        end
    end

    def show
        # If a profile already exists, redirect to the profile. Or else create a new one
        if get_profile.present?
            @profile = get_profile
        else
            flash[:notice] = "Please create a profile below."
            redirect_to user_profile_new_path
        end
    end

    def view
        # Show profile if it exists, or else just redirect to own user profile
        if not current_user.profile.blank? and current_user.profile.id == params[:id].to_i
            redirect_to user_profile_show_path
        else
            @profile = Profile.find(params[:id])
        end
    end

    def update
        # A method to update the profile based on allowed params
        @profile = get_profile
        respond_to do |format|
            if @profile.update(permitted_params)    
                format.html { redirect_to user_profile_show_path, notice: "Profile was successfully updated." }
                format.json { render :show, status: :ok }
            else
              flash[:alert] = "There was an error in updating your profile."
              format.html { render :show, status: :unprocessable_entity }
              format.json { render json: @profile.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        def get_profile
            current_user.profile
        end

        def permitted_params
            params.require(:profile).permit(:firstname, :lastname, :bsb, :account, :image)
        end
end