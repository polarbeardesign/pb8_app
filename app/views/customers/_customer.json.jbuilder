json.extract! customer, :id, :org_name, :short_name, :logo, :require_name, :quoted_rate, :user_id, :reverse_logo, :created_at, :updated_at
json.url customer_url(customer, format: :json)
