require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @project_params = {
      name: "New Project",
      description: "This is a new project",
      status: "active",
      user_id: @user.id
    }
  end

  test "should be valid" do
    project = build(:project, @project_params)
    assert project.valid?
  end

  test "name should not be nil" do
    project = build(:project, @project_params.merge(name: nil))
    assert_not project.valid?
  end

  test "name should not be too long" do
    project = build(:project, @project_params.merge(name: "a" * 999))
    assert_not project.valid?
  end

  test "description should not be too long" do
    project = build(:project, @project_params.merge(description: "a" * 9999))
    assert_not project.valid?
  end

  test "status should not be invalid" do
    project = build(:project, @project_params.merge(status: "invalid"))
    assert_not project.valid?
  end

  test "status should default to 'active' if not provided" do
    project = build(:project, @project_params.except(:status))
    assert_equal "active", project.status
  end

  test "user_id should not be nil" do
    project = build(:project, @project_params.merge(user_id: nil))
    assert_not project.valid?
  end
end
