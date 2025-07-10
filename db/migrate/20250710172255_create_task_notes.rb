class CreateTaskNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :task_notes do |t|
      t.string :title
      t.text :description
      t.references :task, null: false

      t.timestamps
    end
  end
end
