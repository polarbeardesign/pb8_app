require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @task = tasks(:one)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
  end

  test "should create task" do
    visit tasks_url
    click_on "New task"

    fill_in "Customer", with: @task.customer_id
    fill_in "Date completed", with: @task.date_completed
    fill_in "Description", with: @task.description
    fill_in "Due date", with: @task.due_date
    fill_in "Invoice", with: @task.invoice_id
    fill_in "Notes", with: @task.notes
    fill_in "Priority", with: @task.priority
    fill_in "Status", with: @task.status
    fill_in "Task name", with: @task.task_name
    click_on "Create Task"

    assert_text "Task was successfully created"
    click_on "Back"
  end

  test "should update Task" do
    visit task_url(@task)
    click_on "Edit this task", match: :first

    fill_in "Customer", with: @task.customer_id
    fill_in "Date completed", with: @task.date_completed
    fill_in "Description", with: @task.description
    fill_in "Due date", with: @task.due_date
    fill_in "Invoice", with: @task.invoice_id
    fill_in "Notes", with: @task.notes
    fill_in "Priority", with: @task.priority
    fill_in "Status", with: @task.status
    fill_in "Task name", with: @task.task_name
    click_on "Update Task"

    assert_text "Task was successfully updated"
    click_on "Back"
  end

  test "should destroy Task" do
    visit task_url(@task)
    click_on "Destroy this task", match: :first

    assert_text "Task was successfully destroyed"
  end
end
