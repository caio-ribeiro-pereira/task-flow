module Api
  class UsersController < ApplicationController
    before_action :authenticate_request!, only: [ :me ]

    def me
      render json: @current_user, serializer: UserSerializer
    end

    def create
      user = User.new(user_params)

      return head :created if user.save

      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
