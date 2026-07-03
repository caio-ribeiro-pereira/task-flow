class Project < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 2000 }
  validates :status, inclusion: { in: [ "active", "archived" ] }

  def initialize(attributes = {})
    super
    self.status ||= "active"
  end
end
