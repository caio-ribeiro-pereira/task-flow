require "test_helper"

class Api::ProjectsTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @project = create(:project, user: @user)
    @token = JsonWebToken.encode({ user_id: @user.id })
    @auth_headers = { "Authorization" => "Bearer #{@token}" }
    @user_with_projects = create(:user, email: "user_with_projects@user.com")
    @active_projects = create_list(:project, 3, user: @user_with_projects, status: "active")
    @archived_projects = create_list(:project, 2, user: @user_with_projects, status: "archived")
    @projects = @active_projects + @archived_projects
    @token_with_projects = JsonWebToken.encode({ user_id: @user_with_projects.id })
    @auth_headers_with_projects = { "Authorization" => "Bearer #{@token_with_projects}" }
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

  test "should not create project when project.name is empty" do
    @project_params[:project][:name] = ""
    post "/api/projetos", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Name can't be blank" ], JSON.parse(response.body)["errors"]
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

  test "should get projects" do
    get "/api/projetos", headers: @auth_headers_with_projects

    assert_response :ok
    assert_equal @projects.length, JSON.parse(response.body).length
  end

  test "should get projects filtered by active status" do
    get "/api/projetos", headers: @auth_headers_with_projects, params: { status: "active" }

    assert_response :ok
    assert_equal @active_projects.length, JSON.parse(response.body).length
  end

  test "should get projects filtered by archived status" do
    get "/api/projetos", headers: @auth_headers_with_projects, params: { status: "archived" }

    assert_response :ok
    assert_equal @archived_projects.length, JSON.parse(response.body).length
  end

  test "should get empty projects when filtered by invalid status" do
    get "/api/projetos", headers: @auth_headers_with_projects, params: { status: "invalid" }

    assert_response :ok
    assert_equal 0, JSON.parse(response.body).length
  end

  test "should update project" do
    update_params = {
      project: {
        name: "Updated Project",
        description: "This is an updated project",
        status: "archived"
      }
    }

    patch "/api/projetos/#{@project.id}", headers: @auth_headers, params: update_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal update_params[:project][:name], json["name"]
    assert_equal update_params[:project][:description], json["description"]
    assert_equal update_params[:project][:status], json["status"]
  end

  test "should not update project when body is empty" do
    patch "/api/projetos/#{@project.id}", headers: @auth_headers, params: {}, as: :json

    assert_response :bad_request
  end

  test "should not update project when project.name is too long" do
    @project_params[:project][:name] = "a" * 999
    patch "/api/projetos/#{@project.id}", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Name is too long (maximum is 100 characters)" ], JSON.parse(response.body)["errors"]
  end

  test "should not update project when project.description is too long" do
    @project_params[:project][:description] = "a" * 2001
    patch "/api/projetos/#{@project.id}", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Description is too long (maximum is 2000 characters)" ], JSON.parse(response.body)["errors"]
  end

  test "should not update project when project.status is invalid" do
    @project_params[:project][:status] = "invalid_status"
    patch "/api/projetos/#{@project.id}", headers: @auth_headers, params: @project_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Status is not included in the list" ], JSON.parse(response.body)["errors"]
  end

  test "should not update project when id is invalid" do
    patch "/api/projetos/invalid_id", headers: @auth_headers, params: @project_params, as: :json

    assert_response :no_content
  end
end
