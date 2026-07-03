class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status, :user_id, :created_at
end
