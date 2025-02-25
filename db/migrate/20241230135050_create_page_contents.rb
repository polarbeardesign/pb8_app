class CreatePageContents < ActiveRecord::Migration[8.0]
  def change
    create_table :page_contents do |t|
      t.string :title
      t.text :copy

      t.timestamps
    end
  end
end
