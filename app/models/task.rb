class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :title, presence: true, length: { maximum: 200 }
  validates :status, presence: true, inclusion: { in: %w[pending in_progress done] }
  validates :priority, presence: true, inclusion: { in: %w[low medium high] }

  validate :project_belongs_to_user_and_is_active!

  before_destroy :ensure_status_is_pending!

  def initialize(attributes = {})
    super
    self.status ||= "pending"
    self.completed_at ||= Time.now if status == "done"
  end

  def project_belongs_to_user_and_is_active!
    return if user_id.nil? || project_id.nil?

    project = user.projects.find_by(id: project_id)

    errors.add(:project_id, "does not belong to user") if project.nil?
    errors.add(:project_id, "is archived") if project && project.status == "archived"
  end

  def ensure_status_is_pending!
    return if status == "pending"

    errors.add(:status, "in progress cannot delete this task") if status == "in_progress"
    errors.add(:status, "done cannot delete this task") if status == "done"
    throw :abort
  end
end
