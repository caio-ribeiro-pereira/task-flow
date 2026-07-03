require "test_helper"

class Api::UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
    @expired_token = JsonWebToken.encode({ user_id: @user.id }, 1.second.ago)
    @auth_headers = { "Authorization" => "Bearer #{@token}" }
    @expired_headers = { "Authorization" => "Bearer #{@expired_token}" }
    @user_params = {
      user: {
        email: @user.email,
        password: @user.password
      }
    }
  end

  test "should get current user when token is valid" do
    get "/api/usuario", headers: @auth_headers

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @user.email, json["email"]
    assert_equal @user.id, json["id"]
  end

  test "should not get current user when token is invalid" do
    get "/api/usuario", headers: { "Authorization" => "Bearer invalid_token" }

    assert_response :unauthorized
  end

  test "should not get current user when token is missing" do
    get "/api/usuario", headers: { "Authorization" => nil }

    assert_response :unauthorized
  end

  test "should not get current user when header is empty" do
    get "/api/usuario", headers: {}

    assert_response :unauthorized
  end

  test "should not get current user when token is expired" do
    get "/api/usuario", headers: @expired_headers

    assert_response :unauthorized
  end

  test "should create user" do
    @user_params[:user][:email] = "novouser@user.com"
    @user_params[:user][:password] = "SenhaSegura123"
    post "/api/cadastrar", params: @user_params, as: :json

    assert_response :created
  end

  test "should not create user with duplicate email" do
    post "/api/cadastrar", params: @user_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Email has already been taken" ], JSON.parse(response.body)["errors"]
  end

  test "should not create user with invalid email" do
    @user_params[:user][:email] = "invalid_email"
    post "/api/cadastrar", params: @user_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Email is invalid" ], JSON.parse(response.body)["errors"]
  end

  test "should not create user when password is too short" do
    @user_params[:user][:email] = "novouser@novouser.com"
    @user_params[:user][:password] = "123"
    post "/api/cadastrar", params: @user_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Password is too short (minimum is 8 characters)" ], JSON.parse(response.body)["errors"]
  end

  test "should not create user with empty email" do
    post "/api/cadastrar", params: {}, as: :json

    assert_response :bad_request
  end
end
