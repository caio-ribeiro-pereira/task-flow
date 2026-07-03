class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.string :status, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
