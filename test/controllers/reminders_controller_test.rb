require "test_helper"

class RemindersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @reminder = reminders(:one)
  end

  test "should get index" do
    get reminders_url
    assert_response :success
  end

  test "index lists open reminders most important first" do
    @reminder.update!(importance: 3)
    reminders(:two).update!(title: "Urgent one", importance: 9)
    get reminders_url
    assert_response :success
    assert_operator response.body.index("Urgent one"), :<, response.body.index(@reminder.title + "</a>") if @reminder.title != "Urgent one"
    assert_select "select[name='reminder[importance]']", minimum: 2
  end

  test "inline completion toggle returns to the list" do
    patch reminder_url(@reminder), params: { inline: 1, reminder: { completed: "1" } }
    assert_redirected_to reminders_url
    assert @reminder.reload.completed?
    get reminders_url
    assert_select "h2", text: "Recently completed"
  end

  test "inline importance change saves and returns to the list" do
    patch reminder_url(@reminder), params: { inline: 1, reminder: { importance: "9" } }
    assert_redirected_to reminders_url
    assert_equal 9, @reminder.reload.importance
  end

  test "rejects importance outside 1..10" do
    patch reminder_url(@reminder), params: { reminder: { importance: "11" } }
    assert_response :unprocessable_entity
    assert_equal 5, @reminder.reload.importance
  end

  test "should get new" do
    get new_reminder_url
    assert_response :success
  end

  test "should create reminder" do
    assert_difference("Reminder.count") do
      post reminders_url, params: { reminder: { change_count: @reminder.change_count, completed: @reminder.completed, description: @reminder.description, due: @reminder.due, position: @reminder.position, reminder_date: @reminder.reminder_date, task_id: @reminder.task_id, time_critical: @reminder.time_critical, title: @reminder.title } }
    end

    assert_redirected_to reminder_url(Reminder.last)
  end

  test "should show reminder" do
    get reminder_url(@reminder)
    assert_response :success
  end

  test "show page displays priority and a start button for open reminders" do
    WorkPeriod.delete_all # fixtures include running periods, which show "In progress" instead of Start
    @reminder.update!(importance: 8, description: "Some **details**", time_critical: true)
    get reminder_url(@reminder)
    assert_response :success
    assert_select "span", text: /Priority 8\/10/
    assert_select "span", text: "Time critical"
    assert_select "form[action='#{work_periods_path}'][data-controller='form-time']" do
      assert_select "input[name='work_period[task_id]'][value='#{@reminder.task_id}']"
      assert_select "input[name='work_period[reminder_id]'][value='#{@reminder.id}']"
      assert_select "input[name='work_period[start_time]'][data-form-time-target='startTime']"
      assert_select "button", text: "Start"
    end
    assert_select "button", text: /Mark done/
    assert_select "strong", text: "details"

    @reminder.update!(completed: true)
    get reminder_url(@reminder)
    assert_select "button", text: "Start", count: 0
    assert_select "button", text: /Reopen/
    assert_select "h1.line-through"
  end

  test "mark done button completes the reminder" do
    get reminder_url(@reminder)
    assert_select "form[action='#{reminder_path(@reminder)}'] input[name='reminder[completed]'][value='true']"
    patch reminder_url(@reminder), params: { reminder: { completed: "true" } }
    assert @reminder.reload.completed?
  end

  test "show displays progress, work periods and sibling reminders" do
    @reminder.update!(estimate_hours: 4)
    now = Time.current
    WorkPeriod.create!(task: @reminder.task, reminder: @reminder, start_time: now - 2.hours, end_time: now, time_note: "did stuff")
    other = Reminder.create!(task: @reminder.task, title: "Sibling one", importance: 5, completed: false)
    get reminder_url(@reminder)
    assert_response :success
    assert_select "#time_progress", text: /2 hrs of 4 hrs/
    assert_select "#time_progress [role=progressbar][aria-valuenow='50']"
    assert_select "#reminder_work_periods", text: /did stuff/
    assert_select "#sibling_reminders a", text: other.title
  end

  test "show handles a reminder with no work and no estimate" do
    get reminder_url(@reminder)
    assert_select "#time_progress", text: /Not started · no estimate/
    assert_select "#reminder_work_periods", text: /No work logged/
  end

  test "index card shows task label above title, estimate and spent lines" do
    @reminder.update!(estimate_hours: 1.5)
    now = Time.current
    WorkPeriod.create!(task: @reminder.task, reminder: @reminder, start_time: now - 1.hour, end_time: now)
    get reminders_url
    assert_response :success
    assert_select "li##{ActionView::RecordIdentifier.dom_id(@reminder)}" do
      assert_select "div", text: @reminder.task_label
      assert_select "div[title='Time estimate']", text: /Estimate: 1.5 hrs/
      assert_select "div[title='Time worked so far']", text: /Spent: 1 hr/
    end
  end

  test "index hides spent line when no work is logged" do
    get reminders_url
    assert_select "div[title='Time worked so far']", count: 0
  end

  test "index does not run a work period query per reminder" do
    3.times { |i| Reminder.create!(task: @reminder.task, title: "Extra #{i}", importance: 5, completed: false) }
    queries = []
    counter = ->(*, payload) { queries << payload[:sql] if payload[:sql] =~ /FROM `work_periods`.*reminder_id/m }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record") { get reminders_url }
    assert_operator queries.size, :<=, 1
  end

  test "should get edit" do
    get edit_reminder_url(@reminder)
    assert_response :success
  end

  test "should update reminder" do
    patch reminder_url(@reminder), params: { reminder: { change_count: @reminder.change_count, completed: @reminder.completed, description: @reminder.description, due: @reminder.due, position: @reminder.position, reminder_date: @reminder.reminder_date, task_id: @reminder.task_id, time_critical: @reminder.time_critical, title: @reminder.title } }
    assert_redirected_to reminder_url(@reminder)
  end

  test "should destroy reminder" do
    assert_difference("Reminder.count", -1) do
      delete reminder_url(@reminder)
    end

    assert_redirected_to reminders_url
  end

  test "estimate can be set from the form and is shown" do
    get new_reminder_url
    assert_select "input[name='reminder[estimate_hours]']"
    r = Reminder.create!(task: @reminder.task, title: "Estimated", importance: 5, completed: false)
    patch reminder_url(r), params: { reminder: { estimate_hours: "1.5" } }
    assert_equal 1.5, r.reload.estimate_hours.to_f
    get reminders_url
    assert_select "div[title='Time estimate']", text: /Estimate: 1.5 hrs/
    get reminder_url(r)
    assert_select "#time_progress", text: /1.5 hrs/
  end

  test "rejects a negative estimate" do
    patch reminder_url(@reminder), params: { reminder: { estimate_hours: "-1" } }
    assert_response :unprocessable_entity
  end

  test "recurrence can be set and the completed repeat shows on the list" do
    get new_reminder_url
    assert_select "select[name='reminder[recurrence]'] option", text: "Weekly"
    patch reminder_url(@reminder), params: { reminder: { recurrence: "weekly" } }
    assert_equal "weekly", @reminder.reload.recurrence
    get reminders_url
    assert_select "span", text: /↻ weekly/
    get reminder_url(@reminder)
    assert_select "span", text: /↻ weekly/
    patch reminder_url(@reminder), params: { inline: 1, reminder: { completed: "1" } }
    get reminders_url
    assert_select "span", text: /↻ weekly/ # the newly created next occurrence
  end

  test "rejects an unknown recurrence" do
    patch reminder_url(@reminder), params: { reminder: { recurrence: "hourly" } }
    assert_response :unprocessable_entity
  end

  test "start button on the list posts a work period for the reminder" do
    WorkPeriod.delete_all # fixtures include running periods, which show "In progress" instead of Start
    get reminders_url
    assert_select "form[action='#{work_periods_path}'] input[name='work_period[reminder_id]'][value='#{@reminder.id}']"
    now = Time.current
    assert_difference("WorkPeriod.count") do
      post work_periods_url, params: { work_period: { task_id: @reminder.task_id, reminder_id: @reminder.id, start_time: now, end_time: now } }
    end
    assert_redirected_to task_url(@reminder.task_id)
    assert_equal @reminder.id, WorkPeriod.order(:id).last.reminder_id
  end

  test "a running task shows In progress instead of Start" do
    now = Time.current
    WorkPeriod.create!(task: @reminder.task, start_time: now, end_time: now)
    get reminder_url(@reminder)
    assert_select "span", text: /In progress/
    assert_select "form[action='#{work_periods_path}']", count: 0
  end

  test "several tasks can be in progress at once" do
    now = Time.current
    WorkPeriod.delete_all
    WorkPeriod.create!(task: reminders(:one).task, start_time: now, end_time: now)
    WorkPeriod.create!(task: reminders(:two).task, start_time: now, end_time: now)
    get reminders_url
    assert_select "span", text: /In progress/, count: 2
    assert_select "form[action='#{work_periods_path}']", count: 0
  end

  test "matrix places open reminders in the right quadrants" do
    Reminder.delete_all
    t = tasks(:one)
    Reminder.create!(task: t, title: "Do me now", importance: 9, due: Date.current + 1, completed: false)
    Reminder.create!(task: t, title: "Plan me", importance: 8, due: Date.current + 60, completed: false)
    Reminder.create!(task: t, title: "Quick one", importance: 2, time_critical: true, completed: false)
    Reminder.create!(task: t, title: "Someday", importance: 1, completed: false)
    Reminder.create!(task: t, title: "Already done", importance: 9, due: Date.current, completed: true)
    get matrix_reminders_url
    assert_response :success
    assert_select "#quadrant_do li", text: /Do me now/
    assert_select "#quadrant_schedule li", text: /Plan me/
    assert_select "#quadrant_delegate li", text: /Quick one/
    assert_select "#quadrant_eliminate li", text: /Someday/
    assert_select "li", text: /Already done/, count: 0
    assert_select "#quadrant_do li a[href='#{reminder_path(Reminder.find_by(title: "Do me now"))}']"
  end

  test "matrix is reachable from the list and shows empty quadrants" do
    get reminders_url
    assert_select "a[href='#{matrix_reminders_path}']", text: "Matrix"
    Reminder.delete_all
    get matrix_reminders_url
    assert_select "p", text: "Nothing here", count: 4
  end
end
