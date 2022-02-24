class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :email_session]
  skip_before_action :is_approved

  def create
    destroy_session if ActiveModel::Type::Boolean.new.cast(params[:destroy_session])
    if current_user.address.present? && current_user.address != params[:address]
      render status: :bad_request, json: {error_message: "User account is linked to different address."} and return
    elsif current_user.address.blank?
      current_user.update(address: params[:address])
    end

    session[:wallet] = params[:wallet]
    session[:balance] = params[:balance]
    session[:address] = params[:address]
    render json: current_user.as_json, message: "Successfully Logged in"
  end

  def destroy
    destroy_session
    render json: {}, message: "Successfully Session destroyed"
  end

  def destroy_session
    cookies["_rarible_session"] = nil
    cookies.delete "_rarible_session"
    #reset_session
    session[:wallet] = nil
    session[:balance] = nil
    session[:address] = nil
  end

  def valid_user
    render json: {user_exists: true}, message: "Successfully validated"
  end

  def login
  end

  def email_session
    viwallet = ViwalletAuth.new
    login_response = viwallet.login({username: params[:user][:email], password: params[:user][:password]})
    if login_response.success?
      user = User.find_or_create_by(email: params[:user][:email])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in Successfully."
    else
      redirect_to login_sessions_path, alert: login_response.message
    end
  end

  def logout
    reset_session
    redirect_to root_path, notice: "You are successfully logged out."
  end
end
