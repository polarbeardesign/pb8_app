json.extract! page_content, :id, :title, :copy, :created_at, :updated_at
json.url page_content_url(page_content, format: :json)
