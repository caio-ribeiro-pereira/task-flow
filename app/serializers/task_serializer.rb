class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :priority, :created_at, :completed_at, :project_id, :user_id
end
