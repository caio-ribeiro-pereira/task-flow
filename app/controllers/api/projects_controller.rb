module Api
  class ProjectsController < ApplicationController
    before_action :authenticate_request!

    def index
      projects = if params[:status].present?
        Project.where(user_id: @current_user.id, status: params[:status])
      else
        Project.where(user_id: @current_user.id)
      end
      render json: projects, each_serializer: ProjectSerializer
    end

    def create
      project = Project.new(project_params)

      if project.save
        render json: project, serializer: ProjectSerializer, status: :ok
      else
        render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      project = Project.find_by(id: params[:id], user_id: @current_user.id)

      if project.present?
        render json: project, serializer: ProjectSerializer, status: :ok
      else
        render json: {}, status: :ok
      end
    end

    def update
      project = Project.find_by(id: params[:id], user_id: @current_user.id)

      return head :no_content unless project

      if project.update(project_params)
        render json: project, serializer: ProjectSerializer, status: :ok
      else
        render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def project_params
      params.require(:project)
        .permit(:name, :description, :status)
        .merge(user_id: @current_user.id)
    end
  end
end
