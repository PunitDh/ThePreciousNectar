class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :get_profile, only: %i[ show update new ]

    def new
        if get_profile.present?
            redirect_to user_profile_show_path
        else
            @profile = Profile.new
        end
    end

    def create
        @profile = Profile.new(permitted_params)
        @profile.user_id = current_user.id

        respond_to do |format|
            if @profile.save
                format.html { redirect_to user_profile_show_path, notice: "Successfully created profile." }
                format.json { render :show, status: :created }                
                # flash[:notice] = "Successfully created profile."
                # redirect_to user_profile_show_path(@profile.id)
            else
              flash[:alert] = "There was an error in creating your profile."
              format.html { render user_profile_new_path, status: :unprocessable_entity }
              format.json { render json: @profile.errors, status: :unprocessable_entity }
            end
        end

        # if @profile.save
        #     flash[:notice] = "Your profile was successfully created."
        # else
        #     flash[:alert] = "There was an error in creating your profile."
        # end
    end

    def show
        if get_profile.present?
            @profile = get_profile
        else
            flash[:notice] = "Please create a profile below."
            redirect_to user_profile_new_path
        end
    end

    def view
        if not current_user.profile.blank? and current_user.profile.id == params[:id].to_i
            redirect_to user_profile_show_path
        else
            @profile = Profile.find(params[:id])
        end
    end

    def update
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