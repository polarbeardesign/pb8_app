json.extract! invoice, :id, :customer_id, :invoice_number, :total_amount, :tax_amount, :invoice_date, :paid, :pdf_address, :button_code, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
