class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :note
      t.integer :position

      t.timestamps
    end
  end
end
