class Reminder < ApplicationRecord
  belongs_to :task
  # acts_as_list
  # reminder_date => if no reminder date use due date

  validates :importance, inclusion: { in: 1..10 }

  scope :sorted, -> { order("completed ASC, position ASC, due ASC") }
  scope :active, -> { where(completed: 0) }

  # reminders page: most important first, then soonest due (undated last)
  scope :by_importance, -> { order(importance: :desc).order(Arel.sql("due IS NULL, due ASC")) }
  scope :recently_done, -> { where(completed: true).order(updated_at: :desc).limit(10) }

  def overdue?
    !completed? && due.present? && due < Date.current
  end

  def task_label
    "#{task.customer.short_name}: #{task.task_name}"
  end

  scope :today, lambda {
    where ("reminders.due IS NOT NULL AND reminders.due <= ?"), (Date.today)
    }

  scope :next, lambda {
    where ("reminders.due IS NOT NULL AND reminders.due > ? AND reminders.due < ?"), (Date.today), (Date.today + 7.days)
    }

  scope :someday, lambda {
    where ("reminders.due IS NOT NULL AND reminders.due > ?"), (Date.today + 7.days)
    }
end
