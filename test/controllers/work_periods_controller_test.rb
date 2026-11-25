require "test_helper"

class WorkPeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @work_period = work_periods(:one)
  end

  test "should get index" do
    get work_periods_url
    assert_response :success
  end

  test "should get weekly summary" do
    get weekly_summary_url
    assert_response :success
  end

  test "should get graphical week" do
    get weekly_url
    assert_response :success
    get weekly_url(year: 2024, week_no: 52)
    assert_response :success
    assert_select ".work-period", minimum: 1
  end

  test "should fall back on invalid week" do
    get weekly_url(year: 2024, week_no: 99)
    assert_response :success
  end

  test "should attach multiple pdfs and images" do
    pdf = fixture_file_upload("sample.pdf", "application/pdf")
    png = fixture_file_upload("sample.png", "image/png")
    patch work_period_url(@work_period), params: { work_period: { billable: "0", files: [ pdf, png ] } }
    assert_equal 2, @work_period.reload.files.count

    # a second upload appends rather than replaces
    patch work_period_url(@work_period), params: { work_period: { billable: "0", files: [ fixture_file_upload("sample.png", "image/png") ] } }
    assert_equal 3, @work_period.reload.files.count

    get work_period_url(@work_period)
    assert_response :success
    assert_select "img", minimum: 1
  end

  test "should reject disallowed file types" do
    txt = fixture_file_upload("bad.txt", "text/plain")
    patch work_period_url(@work_period), params: { work_period: { billable: "0", files: [ txt ] } }
    assert_response :unprocessable_entity
    assert_equal 0, @work_period.reload.files.count
  end

  test "should remove ticked attachments" do
    @work_period.files.attach(io: file_fixture("sample.png").open, filename: "sample.png", content_type: "image/png")
    att = @work_period.files_attachments.first
    patch work_period_url(@work_period), params: { work_period: { billable: "0" }, remove_file_ids: [ att.id ] }
    assert_equal 0, @work_period.reload.files.count
  end

  test "should get new" do
    get new_work_period_url
    assert_response :success
  end

  test "should create work_period" do
    assert_difference("WorkPeriod.count") do
      post work_periods_url, params: { work_period: { billable: @work_period.billable, end_time: @work_period.end_time, start_time: @work_period.start_time, task_id: @work_period.task_id, time_note: @work_period.time_note } }
    end

    assert_redirected_to task_url(@work_period.task_id)
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
    assert_redirected_to task_url(@work_period.task_id)
  end

  test "should destroy work_period" do
    assert_difference("WorkPeriod.count", -1) do
      delete work_period_url(@work_period)
    end

    assert_redirected_to work_periods_url
  end

  test "create stores the reminder it was started from" do
    reminder = reminders(:one)
    now = Time.current
    assert_difference("WorkPeriod.count") do
      post work_periods_url, params: { work_period: { task_id: reminder.task_id, reminder_id: reminder.id, start_time: now, end_time: now } }
    end
    assert_equal reminder.id, WorkPeriod.order(:id).last.reminder_id
  end
end
