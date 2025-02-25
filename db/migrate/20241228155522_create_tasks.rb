class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.text :description
      t.text :notes
      t.string :status
      t.date :due_date
      t.date :date_completed
      t.string :priority
      t.references :customer
      t.references :invoice

      t.timestamps
    end
  end
end
