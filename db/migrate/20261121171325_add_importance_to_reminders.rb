class AddImportanceToReminders < ActiveRecord::Migration[8.0]
  def change
    # 1 (low) .. 10 (high); existing reminders get a middling default
    add_column :reminders, :importance, :integer, default: 5, null: false
  end
end
