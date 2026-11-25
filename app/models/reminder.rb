class Reminder < ApplicationRecord
  belongs_to :task
  has_many :work_periods, dependent: :nullify
  # acts_as_list
  # reminder_date => if no reminder date use due date

  validates :importance, inclusion: { in: 1..10 }
  RECURRENCES = %w[daily weekly monthly yearly].freeze
  validates :recurrence, inclusion: { in: RECURRENCES }, allow_blank: true
  before_validation { self.recurrence = nil if recurrence.blank? }
  after_save :spawn_next_occurrence, if: -> { saved_change_to_completed?(to: true) && recurrence.present? }

  validates :estimate_hours, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

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

  # Hours logged against this reminder (finished work periods only). Sums the
  # association in Ruby so a preloaded `includes(:work_periods)` avoids N+1.
  def hours_spent
    (work_periods.sum(&:duration) / 3600.0).round(2)
  end

  def estimate_label
    return if estimate_hours.nil?

    hours = estimate_hours.to_f
    "#{format('%g', hours)} #{hours == 1 ? 'hr' : 'hrs'}"
  end

  # Eisenhower matrix: important = priority 6+, urgent = time critical, overdue or due within a week
  IMPORTANT_AT = 6
  URGENT_WITHIN_DAYS = 7

  def important?
    importance >= IMPORTANT_AT
  end

  def urgent?
    time_critical? || (due.present? && due <= Date.current + URGENT_WITHIN_DAYS)
  end

  def quadrant
    if important? then (urgent? ? :do : :schedule)
    else (urgent? ? :delegate : :eliminate)
    end
  end

  def next_due_date
    step = { "daily" => 1.day, "weekly" => 1.week, "monthly" => 1.month, "yearly" => 1.year }.fetch(recurrence)
    date = (due || Date.current) + step
    # if it was finished late, keep stepping until the next due date is in the future
    date += step while date <= Date.current
    date
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

  private

  # Completing a repeating reminder queues up the next one. Skips if an
  # identical open one already exists (e.g. reopened and completed again).
  def spawn_next_occurrence
    next_due = next_due_date
    return if Reminder.active.exists?(task_id: task_id, title: title, recurrence: recurrence, due: next_due)

    shift = next_due - (due || Date.current)
    Reminder.create!(
      task_id: task_id, title: title, description: description, importance: importance,
      time_critical: time_critical, estimate_hours: estimate_hours, recurrence: recurrence,
      position: position, change_count: 0, completed: false,
      due: next_due, reminder_date: reminder_date && reminder_date + shift
    )
  end
end
