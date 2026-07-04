# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(email: "test@seed.com", password: "password", password_confirmation: "password")
active_project = Project.create!(name: "Project Active", description: "This is a new active project", status: "active", user: user)
archived_project = Project.create!(name: "Project Archived", description: "This is a new project archived", status: "archived", user: user)

Task.create!(title: "New Task 1", description: "This is a new task", status: "pending", priority: "low", project: active_project, user: user)
Task.create!(title: "New Task 2", description: "This is a new task", status: "in_progress", priority: "medium", project: active_project, user: user)
Task.create!(title: "New Task 3", description: "This is a new task", status: "done", priority: "high", project: active_project, user: user)

Task.create!(title: "New Task 4", description: "This is a new task", status: "done", priority: "low", project: archived_project, user: user)
Task.create!(title: "New Task 5", description: "This is a new task", status: "done", priority: "medium", project: archived_project, user: user)
Task.create!(title: "New Task 6", description: "This is a new task", status: "done", priority: "high", project: archived_project, user: user)

user_2 = User.create!(email: "test2@seed.com", password: "password2", password_confirmation: "password2")
active_project_2 = Project.create!(name: "Project Active 2", description: "This is a new active project", status: "active", user: user_2)
archived_project_2 = Project.create!(name: "Project Archived 2", description: "This is a new project archived", status: "archived", user: user_2)

Task.create!(title: "New Task A", description: "This is a new task", status: "pending", priority: "low", project: active_project_2, user: user_2)
Task.create!(title: "New Task B", description: "This is a new task", status: "in_progress", priority: "medium", project: active_project_2, user: user_2)
Task.create!(title: "New Task C", description: "This is a new task", status: "done", priority: "high", project: active_project_2, user: user_2)

Task.create!(title: "New Task D", description: "This is a new task", status: "done", priority: "low", project: archived_project_2, user: user_2)
Task.create!(title: "New Task E", description: "This is a new task", status: "done", priority: "medium", project: archived_project_2, user: user_2)
Task.create!(title: "New Task F", description: "This is a new task", status: "done", priority: "high", project: archived_project_2, user: user_2)
