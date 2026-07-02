require 'test_helper'

class Api::SessionsTest < ActionDispatch::IntegrationTest
  setup do
    @created_user = create(:user)
  end

  test "should authenticate user" do
    post '/api/login', params: { email: @created_user.email, password: @created_user.password }, as: :json

    assert_response :ok

    json_response = JSON.parse(response.body)
    assert_equal json_response['email'], @created_user.email
    assert json_response['token'].present?
    assert json_response['exp'].present?
  end

  test "should not authenticate user with incorrect credentials" do
    post '/api/login', params: { email: @created_user.email, password: 'IncorrectPassword' }, as: :json

    assert_response :unauthorized
  end
  
  test "should not authenticate user with email invalid format" do
    post '/api/login', params: { email: 'invalid_email', password: @created_user.password }, as: :json

    assert_response :unauthorized
  end

  test "should not authenticate user with invalid body" do
    post '/api/login', params: { username: 'teste' }, as: :json

    assert_response :unauthorized
  end

  test "should not authenticate user with empty body" do
    post '/api/login', params: {}, as: :json

    assert_response :unauthorized
  end
end