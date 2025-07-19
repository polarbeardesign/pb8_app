class NoteCategory < ApplicationRecord
	has_and_belongs_to_many :notes
	scope :single, lambda { |query| where(:id => query) }
	scope :alpha_ordered, -> { order('category_name ASC') }
end
