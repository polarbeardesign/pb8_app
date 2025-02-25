require "application_system_test_case"

class RemindersTest < ApplicationSystemTestCase
  setup do
    @reminder = reminders(:one)
  end

  test "visiting the index" do
    visit reminders_url
    assert_selector "h1", text: "Reminders"
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
    click_on "Create Reminder"

    assert_text "Reminder was successfully created"
    click_on "Back"
  end

  test "should update Reminder" do
    visit reminder_url(@reminder)
    click_on "Edit this reminder", match: :first

    fill_in "Change count", with: @reminder.change_count
    check "Completed" if @reminder.completed
    fill_in "Description", with: @reminder.description
    fill_in "Due", with: @reminder.due
    fill_in "Position", with: @reminder.position
    fill_in "Reminder date", with: @reminder.reminder_date
    fill_in "Task", with: @reminder.task_id
    check "Time critical" if @reminder.time_critical
    fill_in "Title", with: @reminder.title
    click_on "Update Reminder"

    assert_text "Reminder was successfully updated"
    click_on "Back"
  end

  test "should destroy Reminder" do
    visit reminder_url(@reminder)
    click_on "Destroy this reminder", match: :first

    assert_text "Reminder was successfully destroyed"
  end
end
