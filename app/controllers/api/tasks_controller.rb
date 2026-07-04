module Api
  class TasksController < ApplicationController
    before_action :authenticate_request!

    def index
      tasks = Task.where(filter_params)
      render json: tasks, each_serializer: TaskSerializer
    end

    def create
      task = Task.new(create_params)

      if task.save
        render json: task, serializer: TaskSerializer, status: :ok
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      task = Task.find_by(id: params[:task_id], user_id: @current_user.id)

      return head :no_content unless task

      if task.update(update_params)
        render json: task, serializer: TaskSerializer, status: :ok
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      task = Task.find_by(id: params[:task_id], user_id: @current_user.id)

      if task.destroy
        head :no_content
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def filter_params
      filter = { user_id: @current_user.id, project_id: params[:project_id] }
      filter[:status] = params[:status] if params[:status].present?
      filter[:priority] = params[:priority] if params[:priority].present?
      filter
    end

    def create_params
      params.require(:task)
        .permit(:title, :description, :status, :priority)
        .merge(user_id: @current_user.id, project_id: params[:project_id])
    end

    def update_params
      create_params.except(:project_id)
    end
  end
end
