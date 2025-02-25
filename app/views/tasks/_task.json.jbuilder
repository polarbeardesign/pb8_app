json.extract! task, :id, :task_name, :description, :notes, :status, :due_date, :date_completed, :priority, :customer_id, :invoice_id, :created_at, :updated_at
json.url task_url(task, format: :json)
