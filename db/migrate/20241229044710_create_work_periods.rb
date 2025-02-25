class CreateWorkPeriods < ActiveRecord::Migration[8.0]
  def change
    create_table :work_periods do |t|
      t.datetime :end_time
      t.datetime :start_time
      t.text :time_note
      t.boolean :billable
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
