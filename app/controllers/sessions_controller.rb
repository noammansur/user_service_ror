# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      Rails.logger.info 'session was updated to hold user id %d' % session[:user_id]
      render json: { message: 'Logged in succesfully', user_id: user.id }
    else

      render json: { message: 'Failure' }
    end
  end

  def destroy
    if session[:user_id]
      Rails.logger.info 'Removing user_id field from session, currently holding %d' % session[:user_id]
    else
      Rails.logger.info 'session is empty'
    end
    session.delete(:user_id)
    render json: { message: 'Signed out' }
  end
end
