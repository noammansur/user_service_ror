# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
    render_user_json @users
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      render json: { message: 'User can not be found' }, status: 404
      return
    end

    render_user_json @user
  end

  def create
    @user = User.new(user_params)
    @user.email.downcase!

    if @user.save
      render_user_json @user
    else
      render json: { message: 'user can not be added', errors: @user.errors }
    end
  end

  def update
    if @current_user.nil?
      render json: { message: 'User is not autorized to perform this action', s: session}, status: 401
      return
    end

    if @current_user.update(user_params)
      render_user_json @current_user
    else
      render json: { message: 'user can not be updated', errors: @current_user.errors }
    end
  end

  private

  def user_params
    # TODO: understand why that don't work: params.require(:user).permit(:first_name, :last_name, :email)
    params.permit(:first_name, :last_name, :email, :password)
  end

  def render_user_json(user)
    render json: user, except: %i[created_at updated_at password_digest]
  end
end
