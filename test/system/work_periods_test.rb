require "application_system_test_case"

class WorkPeriodsTest < ApplicationSystemTestCase
  setup do
    @work_period = work_periods(:one)
  end

  test "visiting the index" do
    visit work_periods_url
    assert_selector "h1", text: "Work periods"
  end

  test "should create work period" do
    visit work_periods_url
    click_on "New work period"

    check "Billable" if @work_period.billable
    fill_in "End time", with: @work_period.end_time
    fill_in "Start time", with: @work_period.start_time
    fill_in "Task", with: @work_period.task_id
    fill_in "Time note", with: @work_period.time_note
    click_on "Create Work period"

    assert_text "Work period was successfully created"
    click_on "Back"
  end

  test "should update Work period" do
    visit work_period_url(@work_period)
    click_on "Edit this work period", match: :first

    check "Billable" if @work_period.billable
    fill_in "End time", with: @work_period.end_time.to_s
    fill_in "Start time", with: @work_period.start_time.to_s
    fill_in "Task", with: @work_period.task_id
    fill_in "Time note", with: @work_period.time_note
    click_on "Update Work period"

    assert_text "Work period was successfully updated"
    click_on "Back"
  end

  test "should destroy Work period" do
    visit work_period_url(@work_period)
    click_on "Destroy this work period", match: :first

    assert_text "Work period was successfully destroyed"
  end
end
