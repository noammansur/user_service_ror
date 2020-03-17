# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def validate_authenticated
    # Look up the current user based on user_id in the session cookie:
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
      if @current_user && @current_user.token != session[:session_token]
        render json: { message: 'Wrong token was given to user' }
      end
    end 
    # Check the token
    render json: { message: 'Guest user can not perform this action, sign in' }, status: 401 unless @current_user
  end
end
