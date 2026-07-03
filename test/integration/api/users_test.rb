require "test_helper"

class Api::UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
  end

  test "should get current user when token is valid" do
    get "/api/usuario", headers: { "Authorization" => "Bearer #{@token}" }

    assert_response :success
    assert_equal @user.email, JSON.parse(response.body)["email"]
    assert_equal @user.id, JSON.parse(response.body)["id"]
  end

  test "should not get current user when token is invalid" do
    get "/api/usuario", headers: { "Authorization" => "Bearer invalid_token" }

    assert_response :unauthorized
  end

  test "should not get current user when token is missing" do
    get "/api/usuario"

    assert_response :unauthorized
  end

  test "should not get current user when token is expired" do
    expired_token = JsonWebToken.encode({ user_id: @user.id }, 1.second.ago)
    get "/api/usuario", headers: { "Authorization" => "Bearer #{expired_token}" }

    assert_response :unauthorized
  end

  test "should create user" do
    post "/api/cadastrar", params: { email: "novouser@user.com", password: "SenhaSegura123" }, as: :json

    assert_response :created
  end

  test "should not create user with duplicate email" do
    post "/api/cadastrar", params: { email: @user.email, password: @user.password }, as: :json

    assert_response :unprocessable_entity
  end

  test "should not create user with invalid email" do
    post "/api/cadastrar", params: { user: { email: "invalido_email", password: "SenhaSegura123" } }, as: :json

    assert_response :unprocessable_entity
  end

  test "should not create user with invalid password" do
    post "/api/cadastrar", params: { user: { email: "user@email.valido.com", password: "123" } }, as: :json

    assert_response :unprocessable_entity
  end

  test "should not create user with invalid body" do
    post "/api/cadastrar", params: {}, as: :json

    assert_response :unprocessable_entity
  end
end
