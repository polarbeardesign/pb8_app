class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :customer
      t.integer :invoice_number
      t.decimal :total_amount, :precision => 8, :scale => 2
      t.decimal :tax_amount, :precision => 8, :scale => 2
      t.date :invoice_date
      t.boolean :paid
      t.string :pdf_address
      t.text :button_code

      t.timestamps
    end
  end
end
