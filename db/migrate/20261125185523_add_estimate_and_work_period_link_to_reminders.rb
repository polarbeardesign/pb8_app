class AddEstimateAndWorkPeriodLinkToReminders < ActiveRecord::Migration[8.0]
  def change
    add_column :reminders, :estimate_hours, :decimal, precision: 5, scale: 2
    # integer to match the legacy integer primary keys on reminders/work_periods
    add_column :work_periods, :reminder_id, :integer
    add_index :work_periods, :reminder_id
  end
end
