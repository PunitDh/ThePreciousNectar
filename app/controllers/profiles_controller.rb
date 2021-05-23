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
              format.html { redirect_to @profile, notice: "Your profile was successfully created." }
              format.json { render :show, status: :created, location: @profile }
            else
              flash[:alert] = "There was an error in creating your profile."
              format.html { render :new, status: :unprocessable_entity }
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

    def update
        @profile = get_profile

        respond_to do |format|
            if @profile.update(permitted_params)
              format.html { redirect_to @profile, notice: "Your profile was successfully updated." }
              format.json { render :show, status: :ok, location: @profile }
            else
              flash[:alert] = "There was an error in updating your profile."
              format.html { render :show, status: :unprocessable_entity }
              format.json { render json: @profile.errors, status: :unprocessable_entity }
            end
        end
        # if @profile.update(permitted_params)
        #     flash[:notice] = "Your profile was successfully updated."
        # else
        #     flash[:alert] = "There was an error in updating your profile."
        # end
        # redirect_to user_profile_show_path
    end

    private
        def get_profile
            current_user.profile
        end

        def permitted_params
            params.require(:profile).permit(:firstname, :lastname, :bsb, :account, :image)
        end
end