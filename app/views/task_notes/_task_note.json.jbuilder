json.extract! task_note, :id, :title, :description, :task_id, :created_at, :updated_at
json.url task_note_url(task_note, format: :json)
