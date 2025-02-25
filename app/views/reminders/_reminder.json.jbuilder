json.extract! reminder, :id, :title, :description, :completed, :time_critical, :task_id, :reminder_date, :due, :change_count, :position, :created_at, :updated_at
json.url reminder_url(reminder, format: :json)
