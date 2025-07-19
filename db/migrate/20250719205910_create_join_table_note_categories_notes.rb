class CreateJoinTableNoteCategoriesNotes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :note_categories, :notes do |t|
      # t.index [:note_category_id, :note_id]
      # t.index [:note_id, :note_category_id]
    end
  end
end
