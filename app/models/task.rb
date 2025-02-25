class Task < ApplicationRecord

  has_many :work_periods, dependent: :destroy
#  has_many :task_notes, dependent: :destroy
  has_many :reminders, dependent: :destroy
#  has_and_belongs_to_many :invoices

  belongs_to :customer
  belongs_to :invoice

# for active tasks
   scope :active, -> { where(:status => "Active") }

# for sorting tasks
  scope :sorted, -> { joins(:customer).merge(Customer.alpha_order).order('task_name ASC') }

# for sorting tasks w/o task name
  scope :cust_sort, -> { joins(:customer).merge(Customer.alpha_order) }

# for sorting by status
  scope :status_sort, -> { order('status ASC, created_at DESC') }

# for adding context to pulldown
  def task_detail
    "#{self.task_name} - #{self.customer.short_name}"
  end

  scope :weekly, -> { joins(:work_periods, :customer).merge(WorkPeriod.weekly).select("tasks.id,tasks.task_name,customer_id,SUM(TIMESTAMPDIFF(SECOND,work_periods.start_time,work_periods.end_time))/3600 AS hour_tot, SUM(IF(billable = 1, (TIMESTAMPDIFF(SECOND,start_time,end_time)/3600), 0)) AS bill_tot").group("tasks.id") }

  scope :current_task, -> { joins(:work_periods).merge(WorkPeriod.current_job) }


end
