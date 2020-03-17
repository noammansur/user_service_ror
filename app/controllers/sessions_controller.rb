# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(email: params[:email].downcase)

    unless user&.authenticate(params[:password])
      render json: { message: 'Failure to authenticate' }
      return
    end

    token = SecureRandom.hex(10)
    session[:user_id] = user.id
    session[:session_token] = token
    user.update(token: token)
    render json: { message: 'Logged in succesfully'}
  end

  def destroy
    unless session[:user_id]
      render json: { message: 'No user was signed in' }
      return
    end
    user = User.find_by_id(session[:user_id])
    user.update(token: nil)
    session.delete(:user_id :session_token)
    render json: { message: 'Signed out' }
  end
end
