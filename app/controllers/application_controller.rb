class ApplicationController < ActionController::API
  attr_accessor :current_user

  def authenticate_request!
    @current_user = load_user_from_token
    unless @current_user
      head :unauthorized
    end
  end

  private

  def load_user_from_token
    auth_header = request.headers["Authorization"]
    return nil if auth_header.blank?

    token = auth_header.split(" ").last
    decoded = JsonWebToken.decode(token)
    return nil unless decoded

    User.find_by(id: decoded[:user_id])
  end
end
