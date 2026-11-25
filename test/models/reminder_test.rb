require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  setup { @reminder = reminders(:one) }

  test "hours_spent is zero with no work periods" do
    assert_equal 0, @reminder.hours_spent
  end

  test "hours_spent sums finished work periods and ignores running ones" do
    now = Time.current.change(usec: 0)
    WorkPeriod.create!(task: @reminder.task, reminder: @reminder, start_time: now - 90.minutes, end_time: now)
    WorkPeriod.create!(task: @reminder.task, reminder: @reminder, start_time: now - 30.minutes, end_time: now)
    WorkPeriod.create!(task: @reminder.task, reminder: @reminder, start_time: now, end_time: now) # running
    WorkPeriod.create!(task: @reminder.task, start_time: now - 5.hours, end_time: now) # other work on the task
    assert_equal 2.0, @reminder.reload.hours_spent
  end

  test "estimate_label" do
    assert_nil @reminder.estimate_label
    @reminder.estimate_hours = 1
    assert_equal "1 hr", @reminder.estimate_label
    @reminder.estimate_hours = 1.5
    assert_equal "1.5 hrs", @reminder.estimate_label
    @reminder.estimate_hours = 4
    assert_equal "4 hrs", @reminder.estimate_label
  end

  test "estimate_hours must not be negative" do
    @reminder.estimate_hours = -1
    assert_not @reminder.valid?
    @reminder.estimate_hours = nil
    assert @reminder.valid?
  end

  test "destroying a reminder keeps its work periods" do
    wp = WorkPeriod.create!(task: @reminder.task, reminder: @reminder, start_time: 1.hour.ago, end_time: Time.current)
    @reminder.destroy!
    assert_nil wp.reload.reminder_id
  end

  test "recurrence must be a known interval" do
    @reminder.recurrence = "fortnightly"
    assert_not @reminder.valid?
    @reminder.recurrence = ""
    assert @reminder.valid?
    assert_nil @reminder.recurrence
  end

  test "completing a repeating reminder creates the next one" do
    @reminder.update!(recurrence: "weekly", due: Date.current + 2, reminder_date: Date.current + 1, estimate_hours: 2, importance: 7, completed: false)
    assert_difference("Reminder.active.count", 0) do # one closed, one opened
      @reminder.update!(completed: true)
    end
    nxt = Reminder.active.where(title: @reminder.title, task_id: @reminder.task_id).order(:id).last
    assert_equal Date.current + 9, nxt.due
    assert_equal Date.current + 8, nxt.reminder_date
    assert_equal "weekly", nxt.recurrence
    assert_equal 7, nxt.importance
    assert_equal 2, nxt.estimate_hours.to_f
    assert_not nxt.completed?
  end

  test "a late repeating reminder rolls forward to a future date" do
    @reminder.update!(recurrence: "daily", due: Date.current - 5, completed: false)
    @reminder.update!(completed: true)
    assert_equal Date.current + 1, Reminder.active.where(title: @reminder.title, task_id: @reminder.task_id).order(:id).last.due
  end

  test "a repeating reminder with no due date repeats from today" do
    @reminder.update!(recurrence: "monthly", due: nil, completed: false)
    @reminder.update!(completed: true)
    assert_equal Date.current + 1.month, Reminder.active.where(title: @reminder.title, task_id: @reminder.task_id).order(:id).last.due
  end

  test "non-repeating reminders do not spawn anything" do
    assert_no_difference("Reminder.count") { @reminder.update!(completed: true) }
  end

  test "reopening and completing again does not duplicate the next occurrence" do
    @reminder.update!(recurrence: "weekly", due: Date.current + 2, completed: false)
    @reminder.update!(completed: true)
    assert_no_difference("Reminder.count") do
      @reminder.update!(completed: false)
      @reminder.update!(completed: true)
    end
  end

  test "quadrant sorts by importance and urgency" do
    r = Reminder.new(importance: 8, due: Date.current + 3)
    assert_equal :do, r.quadrant
    r.due = Date.current + 30
    assert_equal :schedule, r.quadrant
    r.due = nil
    r.time_critical = true
    assert_equal :do, r.quadrant
    r.importance = 3
    assert_equal :delegate, r.quadrant
    r.time_critical = false
    assert_equal :eliminate, r.quadrant
    r.due = Date.current - 2 # overdue counts as urgent
    assert_equal :delegate, r.quadrant
  end

  test "importance threshold is 6" do
    assert Reminder.new(importance: 6).important?
    assert_not Reminder.new(importance: 5).important?
  end

  test "urgency window is 7 days inclusive" do
    assert Reminder.new(importance: 5, due: Date.current + 7).urgent?
    assert_not Reminder.new(importance: 5, due: Date.current + 8).urgent?
  end
end
