require "test_helper"

class WorkPeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_period = work_periods(:one)
  end

  test "should get index" do
    get work_periods_url
    assert_response :success
  end

  test "should get new" do
    get new_work_period_url
    assert_response :success
  end

  test "should create work_period" do
    assert_difference("WorkPeriod.count") do
      post work_periods_url, params: { work_period: { billable: @work_period.billable, end_time: @work_period.end_time, start_time: @work_period.start_time, task_id: @work_period.task_id, time_note: @work_period.time_note } }
    end

    assert_redirected_to work_period_url(WorkPeriod.last)
  end

  test "should show work_period" do
    get work_period_url(@work_period)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_period_url(@work_period)
    assert_response :success
  end

  test "should update work_period" do
    patch work_period_url(@work_period), params: { work_period: { billable: @work_period.billable, end_time: @work_period.end_time, start_time: @work_period.start_time, task_id: @work_period.task_id, time_note: @work_period.time_note } }
    assert_redirected_to work_period_url(@work_period)
  end

  test "should destroy work_period" do
    assert_difference("WorkPeriod.count", -1) do
      delete work_period_url(@work_period)
    end

    assert_redirected_to work_periods_url
  end
end
