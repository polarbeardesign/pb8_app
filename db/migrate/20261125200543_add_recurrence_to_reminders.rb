class AddRecurrenceToReminders < ActiveRecord::Migration[8.0]
  def change
    add_column :reminders, :recurrence, :string
  end
end
