class OmniauthController < ApplicationController
    def facebook
        @user = User.create_from_provider_data(request.env['omniauth.auth'])
        if @user.persisted?
            flash[:notice] = "Successfully signed in using Facebook."
            sign_in_and_redirect @user
        else
            flash[:alert] = "There was a problem signing you in through Facebook. Please use another sign-in method."
            redirect_to new_user_session_url
        end
    end

    def github
        @user = User.create_from_provider_data(request.env['omniauth.auth'])
        if @user.persisted?
            flash[:notice] = "Successfully signed in using GitHub."
            sign_in_and_redirect @user
        else
            flash[:alert] = "There was a problem signing you in through GitHub. Please use another sign-in method."
            redirect_to new_user_session_url
        end
    end

    def google_oauth2
        @user = User.from_omniauth(request.env['omniauth.auth'])
        if @user.persisted?
            flash[:notice] = "Successfully signed in using Google."
            sign_in_and_redirect @user, event: :authentication
        else
            session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
            flash[:alert] = "There was a problem signing you in through Google. Please use another sign-in method."
            redirect_to new_user_session_url, alert: @user.errors.full_messages.join("\n")
        end
    end

    def failure
        flash[:alert] = "There was a problem signing you in. Please use another sign-in method."
        redirect_to new_user_registration_url
    end

    private
        def oauth(provider)
            
        end

end
