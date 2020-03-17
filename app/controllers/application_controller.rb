class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def current_user
    # Look up the current user based on user_id in the session cookie:
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
