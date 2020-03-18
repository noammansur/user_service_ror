# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_authenticated, only: %i[update show]

  def index
    @users = User.all
    render json: @users.map { |user|
                   ::Presenters::User::UserPresenter.new(user).generate
                 }
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      render json: { message: 'User can not be found' }, status: 404
      return
    end

    render json: ::Presenters::User::UserPresenter.new(@user).generate
  end

  def create
    user = ::Contexts::Users::UserContext.new.register(params)
    present_based_on_errors(user)
  end

  def update
    user = ::Contexts::Users::UserContext.new.update(params)
    present_based_on_errors(user)
  end

  def sign_in
    user = ::Contexts::Users::UserContext.new.sign_in(params[:email], params[:password], session)
    if user
      render json: { message: 'Logged in succesfully', user_id: user.id }
    else
      render json: { message: 'Autentication failed' }
    end
  end

  def sign_out
    ::Contexts::Users::UserContext.new.sign_out(session)
    render json: { message: 'Signed out' }
  end

  private

  def validate_authenticated
    @user = User.find_by_id(params.fetch(:id))

    unless @user && @user.token == session[:session_token]
      render nothing: true, status: :unauthorized
      return
    end
  end

  def present_based_on_errors(user)
    if user.errors.empty?
      render json: ::Presenters::User::UserPresenter.new(user).generate
    else
      render json: { message: 'Action can not be performed', errors: user.errors }
    end
  end
end
