require "test_helper"

class TaskNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_note = task_notes(:one)
  end

  test "should get index" do
    get task_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_task_note_url
    assert_response :success
  end

  test "should create task_note" do
    assert_difference("TaskNote.count") do
      post task_notes_url, params: { task_note: { description: @task_note.description, task_id: @task_note.task_id, title: @task_note.title } }
    end

    assert_redirected_to task_note_url(TaskNote.last)
  end

  test "should show task_note" do
    get task_note_url(@task_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_note_url(@task_note)
    assert_response :success
  end

  test "should update task_note" do
    patch task_note_url(@task_note), params: { task_note: { description: @task_note.description, task_id: @task_note.task_id, title: @task_note.title } }
    assert_redirected_to task_note_url(@task_note)
  end

  test "should destroy task_note" do
    assert_difference("TaskNote.count", -1) do
      delete task_note_url(@task_note)
    end

    assert_redirected_to task_notes_url
  end
end
