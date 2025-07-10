class Customer < ApplicationRecord
  belongs_to :user
  has_many :customer_accounts, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :work_periods, through: :tasks

  scope :alpha_order, -> { order(:org_name) }
  scope :recent, -> { joins(:work_periods).select("customers.id,org_name,quoted_rate,MAX(work_periods.end_time) AS latest").group("org_name").order("latest DESC") }
  scope :weekly, -> { joins(:work_periods, :tasks).merge(WorkPeriod.weekly).order(:org_name) }
end
