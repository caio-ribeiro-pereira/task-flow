require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = create(:user, email: "new_task@mail.com")
    @project = create(:project, user: @user)
    @archived_project = create(:project, :archived, user: @user)
    @task_params = {
      title: "New Task",
      description: "This is a new task",
      status: "pending",
      priority: "low",
      user_id: @user.id,
      project_id: @project.id
    }

    @another_user = create(:user, email: "another_task@mail.com")
    @another_project = create(:project, user: @another_user)
  end

  test "should be valid" do
    task = build(:task, @task_params)
    assert task.valid?
  end

  test "title should not be nil" do
    task = build(:task, @task_params.merge(title: nil))
    assert_not task.valid?
  end

  test "title should not be too long" do
    task = build(:task, @task_params.merge(title: "a" * 999))
    assert_not task.valid?
  end

  test "status should not be nil" do
    task = build(:task, @task_params.merge(status: nil))
    assert_not task.valid?
  end

  test "status should not be invalid" do
    task = build(:task, @task_params.merge(status: "invalid"))
    assert_not task.valid?
  end

  test "status should default to 'pending' if not provided" do
    task = build(:task, @task_params.except(:status))
    assert_equal "pending", task.status
  end

  test "priority should not be nil" do
    task = build(:task, @task_params.merge(priority: nil))
    assert_not task.valid?
  end

  test "priority should not be invalid" do
    task = build(:task, @task_params.merge(priority: "invalid"))
    assert_not task.valid?
  end

  test "project should belong to user" do
    task = build(:task, @task_params.merge(project_id: @another_project.id))
    assert_not task.valid?
  end

  test "project should be active" do
    task = build(:task, @task_params.merge(project_id: @archived_project.id))
    assert_not task.valid?
  end
end
