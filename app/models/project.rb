class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 2000 }
  validates :status, inclusion: { in: %w[active archived] }

  def initialize(attributes = {})
    super
    self.status ||= "active"
  end
end
