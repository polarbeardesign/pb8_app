class Reminder < ApplicationRecord
  belongs_to :task
  # acts_as_list
  # reminder_date => if no reminder date use due date

  scope :sorted, -> { order("completed ASC, position ASC, due ASC") }
  scope :active, -> { where(completed: 0) }

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
