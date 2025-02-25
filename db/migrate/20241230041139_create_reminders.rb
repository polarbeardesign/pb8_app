class CreateReminders < ActiveRecord::Migration[8.0]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :description
      t.boolean :completed
      t.boolean :time_critical
      t.references :task, null: false
      t.date :reminder_date
      t.date :due
      t.integer :change_count
      t.integer :position

      t.timestamps
    end
  end
end
