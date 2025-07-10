require "application_system_test_case"

class TaskNotesTest < ApplicationSystemTestCase
  setup do
    @task_note = task_notes(:one)
  end

  test "visiting the index" do
    visit task_notes_url
    assert_selector "h1", text: "Task notes"
  end

  test "should create task note" do
    visit task_notes_url
    click_on "New task note"

    fill_in "Description", with: @task_note.description
    fill_in "Task", with: @task_note.task_id
    fill_in "Title", with: @task_note.title
    click_on "Create Task note"

    assert_text "Task note was successfully created"
    click_on "Back"
  end

  test "should update Task note" do
    visit task_note_url(@task_note)
    click_on "Edit this task note", match: :first

    fill_in "Description", with: @task_note.description
    fill_in "Task", with: @task_note.task_id
    fill_in "Title", with: @task_note.title
    click_on "Update Task note"

    assert_text "Task note was successfully updated"
    click_on "Back"
  end

  test "should destroy Task note" do
    visit task_note_url(@task_note)
    click_on "Destroy this task note", match: :first

    assert_text "Task note was successfully destroyed"
  end
end
