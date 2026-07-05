require "test_helper"

class Api::TasksTest < ActionDispatch::IntegrationTest
  setup do
    @user_no_project = create(:user)
    @token = JsonWebToken.encode({ user_id: @user_no_project.id })
    @auth_headers_no_project = { "Authorization" => "Bearer #{@token}" }
    @user_with_projects = create(:user, email: "user_with_projects@user.com")
    @active_project = create(:project, user: @user_with_projects)
    @tasks_for_active_project = create_list(:task, 3, project: @active_project, user: @user_with_projects)
    @archived_project = create(:project, user: @user_with_projects)
    @tasks_for_archived_project = create_list(:task, 3, :completed, project: @archived_project, user: @user_with_projects)
    @archived_project.update!(status: "archived")
    @token_with_projects = JsonWebToken.encode({ user_id: @user_with_projects.id })
    @auth_headers_with_projects = { "Authorization" => "Bearer #{@token_with_projects}" }
    @task_params = {
      task: {
        title: "NEW TASK TITLE",
        description: "This is a new task",
        priority: "low"
      }
    }
  end

  test "should create task for active project" do
    post "/api/projetos/#{@active_project.id}/tarefas", headers: @auth_headers_with_projects, params: @task_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @task_params[:task][:title], json["title"]
    assert_equal @active_project.id, json["project_id"]
    assert_equal @user_with_projects.id, json["user_id"]
  end

  test "should create task with status done" do
    @task_params[:task][:status] = "done"
    post "/api/projetos/#{@active_project.id}/tarefas", headers: @auth_headers_with_projects, params: @task_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @task_params[:task][:title], json["title"]
    assert_equal @task_params[:task][:status], json["status"]
    assert_not_nil json["completed_at"]
    assert_equal @active_project.id, json["project_id"]
    assert_equal @user_with_projects.id, json["user_id"]
  end

  test "should not create task for archived project" do
    post "/api/projetos/#{@archived_project.id}/tarefas", headers: @auth_headers_with_projects, params: @task_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Project is archived" ], JSON.parse(response.body)["errors"]
  end

  test "should not create task for project from another user" do
    post "/api/projetos/#{@active_project.id}/tarefas", headers: @auth_headers_no_project, params: @task_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Project does not belong to user" ], JSON.parse(response.body)["errors"]
  end

  test "should return all tasks" do
    get "/api/projetos/#{@active_project.id}/tarefas", headers: @auth_headers_with_projects

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @tasks_for_active_project.count, json.count
  end

  test "should return tasks filtered by status" do
    get "/api/projetos/#{@active_project.id}/tarefas?status=pending", headers: @auth_headers_with_projects

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 3, json.count
  end

  test "should return tasks filtered by priority" do
    get "/api/projetos/#{@active_project.id}/tarefas?priority=low", headers: @auth_headers_with_projects

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 3, json.count
  end

  test "should return tasks filtered by status and priority" do
    get "/api/projetos/#{@active_project.id}/tarefas?status=pending&priority=low", headers: @auth_headers_with_projects

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 3, json.count
  end

  test "should delete task if status is pending" do
    task_pending = create(:task, :pending, project: @active_project, user: @user_with_projects)
    delete "/api/tarefas/#{task_pending.id}", headers: @auth_headers_with_projects

    assert_response :no_content
  end

  test "should not delete task if status is in_progress" do
    task_in_progress = create(:task, :in_progress, project: @active_project, user: @user_with_projects)
    delete "/api/tarefas/#{task_in_progress.id}", headers: @auth_headers_with_projects

    assert_response :unprocessable_entity
    assert_equal [ "Status in progress cannot delete this task" ], JSON.parse(response.body)["errors"]
  end

  test "should not delete task if status is done" do
    task_completed = create(:task, :completed, project: @active_project, user: @user_with_projects)
    delete "/api/tarefas/#{task_completed.id}", headers: @auth_headers_with_projects

    assert_response :unprocessable_entity
    assert_equal [ "Status done cannot delete this task" ], JSON.parse(response.body)["errors"]
  end

  test "should update task" do
    task = create(:task, project: @active_project, user: @user_with_projects)
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: @task_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal @task_params[:task][:title], json["title"]
    assert_equal @active_project.id, json["project_id"]
    assert_equal @user_with_projects.id, json["user_id"]
  end

  test "should update task status pending to in_progress" do
    task = create(:task, :pending, project: @active_project, user: @user_with_projects)
    task_in_progress_params = { task: { status: "in_progress" } }
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: task_in_progress_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal "in_progress", json["status"]
  end

  test "should update task status in_progress to done" do
    task = create(:task, :in_progress, project: @active_project, user: @user_with_projects)
    task_done_params = { task: { status: "done" } }
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: task_done_params, as: :json

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal "done", json["status"]
  end

  test "should not update task status pending to done" do
    task = create(:task, :pending, project: @active_project, user: @user_with_projects)
    task_done_params = { task: { status: "done" } }
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: task_done_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Status cannot change from pending to done" ], JSON.parse(response.body)["errors"]
  end

  test "should not update task status in_progress to pending" do
    task = create(:task, :in_progress, project: @active_project, user: @user_with_projects)
    task_pending_params = { task: { status: "pending" } }
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: task_pending_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Status cannot change from in progress to pending" ], JSON.parse(response.body)["errors"]
  end

  test "should not update task status done to in_progress" do
    task = create(:task, :completed, project: @active_project, user: @user_with_projects)
    task_in_progress_params = { task: { status: "in_progress" } }
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: task_in_progress_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Status cannot change from done to in progress" ], JSON.parse(response.body)["errors"]
  end

  test "should not update task status done to pending" do
    task = create(:task, :completed, project: @active_project, user: @user_with_projects)
    task_pending_params = { task: { status: "pending" } }
    patch "/api/tarefas/#{task.id}", headers: @auth_headers_with_projects, params: task_pending_params, as: :json

    assert_response :unprocessable_entity
    assert_equal [ "Status cannot change from done to pending" ], JSON.parse(response.body)["errors"]
  end
end
