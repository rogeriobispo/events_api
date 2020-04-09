class V1::UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :show, :update]

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user.update(user_params)
    render json: @user.reload
  end

  def index
    render json: User.all
  end

  def show
    render json: @user if @user
  end

  def destroy
    @user.destroy
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :name, :time_zone)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
