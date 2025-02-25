class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :org_name
      t.string :short_name
      t.string :logo
      t.boolean :require_name
      t.decimal :quoted_rate, :precision => 8, :scale => 2
      t.references :user, null: true
      t.string :reverse_logo

      t.timestamps
    end
  end
end
