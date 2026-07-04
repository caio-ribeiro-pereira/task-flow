class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title, null: false
      t.text :description
      t.string :status, null: false
      t.string :priority, null: false
      t.datetime :completed_at
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
