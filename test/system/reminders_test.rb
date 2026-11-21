require "application_system_test_case"

class RemindersTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:one)
    @reminder = reminders(:one)
  end

  test "visiting the index" do
    visit reminders_url
    assert_selector "h1", text: "Reminders"
  end

  test "completing and re-prioritising from the list saves without a button" do
    visit reminders_url
    within "##{dom_id(@reminder)}" do
      find("select[aria-label='Priority']").select("9")
    end
    assert_text "Reminder was successfully updated"
    assert_equal 9, @reminder.reload.importance

    within "##{dom_id(@reminder)}" do
      find("input[type=checkbox][aria-label='Completed']").check
    end
    assert_text "Recently completed"
    assert @reminder.reload.completed?
  end

  test "should create reminder" do
    visit reminders_url
    click_on "New reminder"

    fill_in "Change count", with: @reminder.change_count
    check "Completed" if @reminder.completed
    fill_in "Description", with: @reminder.description
    fill_in "Due", with: @reminder.due
    fill_in "Position", with: @reminder.position
    fill_in "Reminder date", with: @reminder.reminder_date
    fill_in "Task", with: @reminder.task_id
    check "Time critical" if @reminder.time_critical
    fill_in "Title", with: @reminder.title
    submit_form "Create Reminder"

    assert_text "Reminder was successfully created"
    click_on "Back"
  end

  test "should update Reminder" do
    visit reminder_url(@reminder)
    click_on "Edit", match: :first

    fill_in "Change count", with: @reminder.change_count
    check "Completed" if @reminder.completed
    fill_in "Description", with: @reminder.description
    fill_in "Due", with: @reminder.due
    fill_in "Position", with: @reminder.position
    fill_in "Reminder date", with: @reminder.reminder_date
    fill_in "Task", with: @reminder.task_id
    check "Time critical" if @reminder.time_critical
    fill_in "Title", with: @reminder.title
    submit_form "Update Reminder"

    assert_text "Reminder was successfully updated"
    click_on "Back"
  end

  test "should destroy Reminder" do
    visit reminder_url(@reminder)
    accept_confirm { click_on "Delete" }

    assert_text "Reminder was successfully destroyed"
  end
end
