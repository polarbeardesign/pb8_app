require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:one)
    @task = tasks(:one)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
  end

  test "should create task" do
    visit tasks_url
    click_on "New task"

    select @task.customer.short_name, from: "Customer", match: :first
    fill_in "Date completed", with: @task.date_completed
    fill_in "Description", with: @task.description
    fill_in "Due date", with: @task.due_date
    fill_in "Notes", with: @task.notes
    fill_in "Priority", with: @task.priority
    fill_in "Status", with: @task.status
    fill_in "Task name", with: @task.task_name
    submit_form "Create Task"

    assert_text "Task was successfully created"
    click_on "Back"
  end

  test "should update Task" do
    visit task_url(@task)
    click_on "Edit this task", match: :first

    select @task.customer.short_name, from: "Customer", match: :first
    fill_in "Date completed", with: @task.date_completed
    fill_in "Description", with: @task.description
    fill_in "Due date", with: @task.due_date
    fill_in "Notes", with: @task.notes
    fill_in "Priority", with: @task.priority
    fill_in "Status", with: @task.status
    fill_in "Task name", with: @task.task_name
    submit_form "Update Task"

    assert_text "Task was successfully updated"
    click_on "Back"
  end

  test "should destroy Task" do
    visit task_url(@task)
    submit_form "Destroy this task"

    assert_text "Task was successfully destroyed"
  end
end
