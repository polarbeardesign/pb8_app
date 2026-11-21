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
end
