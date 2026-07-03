require "test_helper"

class Api::ProjectsTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @project = create(:project, user: @user)
    @token = JsonWebToken.encode({ user_id: @user.id })
    @auth_headers = { "Authorization" => "Bearer #{@token}" }
    @project_params = {
      project: {
        name: "New Project",
        description: "This is a new project",
        status: "active"
      }
    }
  end

  test "should create project" do
    post "/api/projetos", headers: @auth_headers, params: @project_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @project_params[:project][:name], json["name"]
    assert_equal @project_params[:project][:description], json["description"]
    assert_equal @project_params[:project][:status], json["status"]
    assert_equal @user.id, json["user_id"]
  end

  test "should not create project when body is empty" do
    post "/api/projetos", headers: @auth_headers, params: {}

    assert_response :bad_request
  end

  test "should not create project when project.name is too long" do
    @project_params[:project][:name] = "a" * 999
    post "/api/projetos", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Name is too long (maximum is 100 characters)" ], JSON.parse(response.body)["errors"]
  end

  test "should not create project when project.description is too long" do
    @project_params[:project][:description] = "a" * 9999
    post "/api/projetos", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Description is too long (maximum is 2000 characters)" ], JSON.parse(response.body)["errors"]
  end

  test "should not create project when project.status is invalid" do
    @project_params[:project][:status] = "invalid_status"
    post "/api/projetos", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Status is not included in the list" ], JSON.parse(response.body)["errors"]
  end

  test "should get project by id" do
    get "/api/projetos/#{@project.id}", headers: @auth_headers

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @project.name, json["name"]
    assert_equal @user.id, json["user_id"]
  end

  test "should not get project by id when id is invalid" do
    get "/api/projetos/invalid_id", headers: @auth_headers

    assert_response :ok
    assert_equal({}, JSON.parse(response.body))
  end

  test "should not get project by id when id belongs to another user" do
    other_user = create(:user, email: "another@email.com")
    other_project = create(:project, user: other_user)
    get "/api/projetos/#{other_project.id}", headers: @auth_headers

    assert_response :ok
    assert_equal({}, JSON.parse(response.body))
  end
end
