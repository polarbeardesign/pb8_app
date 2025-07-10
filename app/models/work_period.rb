class WorkPeriod < ApplicationRecord
  belongs_to :task
  has_one :commute, dependent: :destroy
  accepts_nested_attributes_for :commute
  scope :time_desc, -> { order(end_time: :desc) }
  scope :billable, -> { where(billable: 1) }
  scope :recent, -> { limit(200) }
  # for use in current week's time summary
  # beginning_of_week defaults to Monday, so subtracting one day from result
  scope :weekly,  lambda { where ("work_periods.end_time > ?"), (DateTime.now.beginning_of_week - 1.day) }
  scope :current_job, -> { where("start_time = end_time") }
end
