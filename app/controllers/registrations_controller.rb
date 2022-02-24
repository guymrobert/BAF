class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user
    skip_before_action :is_approved
  
    def new
        @user = User.new
    end

    def create
        viwallet = ViwalletAuth.new
        if params[:user][:password] != params[:user][:password_confirmation]
            redirect_to new_registration_path, alert: "Passwords do not match." and return
        end
        register_response = viwallet.register({email: params[:user][:email], password: params[:user][:password], dataProtection: "yes", preferredLanguage: "en"})
        if register_response.success?
            redirect_to root_path, notice: "Verfication mail has been sent to your email. Please confirm it and login."
        else
            redirect_to new_registration_path, alert: register_response.message
        end
    end

    def resend_confirmation
    end

    def resend
        viwallet = ViwalletAuth.new
        resend_response = viwallet.resend_confirmation({email: params[:email]})
        if resend_response.success?
            redirect_to root_path, notice: "Confirmation email successfully sent."
        else
            redirect_to resend_confirmation_registrations_path, alert: resend_response.message
        end
    end

end
  