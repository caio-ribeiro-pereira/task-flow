module Api
  class SessionsController < ApplicationController
    def create
      return head :unauthorized unless has_valid_params?

      user = User.find_by(email: params[:email])

      return head :unauthorized unless user.present?
      return head :unauthorized unless user.authenticate(params[:password])

      token = JsonWebToken.encode({ user_id: user.id })

      render json: { token: token, exp: Time.now + 48.hours, email: user.email }, status: :ok
    end

    def has_valid_params?
      params[:email].present? &&
      params[:password].present? &&
      URI::MailTo::EMAIL_REGEXP.match?(params[:email]).present? &&
      params[:password].length >= 8
    end
  end
end
