require "test_helper"

class WorkPeriodTest < ActiveSupport::TestCase
  test "duration is the seconds between start and end" do
    now = Time.current.change(usec: 0)
    assert_equal 5400, WorkPeriod.new(start_time: now - 90.minutes, end_time: now).duration
  end

  test "duration is zero for a running or incomplete period" do
    now = Time.current
    assert_equal 0, WorkPeriod.new(start_time: now, end_time: now).duration
    assert_equal 0, WorkPeriod.new(start_time: now).duration
  end

  test "reminder is optional" do
    wp = WorkPeriod.new(task: tasks(:one), start_time: 1.hour.ago, end_time: Time.current)
    assert wp.valid?
    wp.reminder = reminders(:one)
    assert wp.valid?
  end

  test "current_job returns every running period" do
    now = Time.current
    WorkPeriod.delete_all
    a = WorkPeriod.create!(task: tasks(:one), start_time: now, end_time: now)
    b = WorkPeriod.create!(task: tasks(:two), start_time: now, end_time: now)
    WorkPeriod.create!(task: tasks(:one), start_time: now - 1.hour, end_time: now)
    assert_equal [ a.id, b.id ].sort, WorkPeriod.current_job.pluck(:id).sort
  end
end
