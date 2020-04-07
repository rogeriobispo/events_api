module V1
  class UsersController < ApplicationController
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
      @User.update(user_params)
      render json: @User.reload
    end

    def index
      render json: User.all
    end

    def show
      render json: @User if @User
    end

    def destroy
      @User.destroy
    end

    private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def set_user
      @User = User.find(params[:id])
    end
  end
end
