class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 2000 }
  validates :status, inclusion: { in: %w[active archived] }

  before_update :ensure_status_archived_has_no_tasks_in_progress!

  def initialize(attributes = {})
    super
    self.status ||= "active"
  end

  def ensure_status_archived_has_no_tasks_in_progress!
    return unless status == "archived"

    if tasks.where(status: "in_progress").exists?
      errors.add(:status, "cannot be archived because there are tasks in progress")
      throw :abort
    end
  end
end
