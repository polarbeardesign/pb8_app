class TaskNotesController < ApplicationController
  before_action :set_task_note, only: %i[ show edit update destroy ]

  # GET /task_notes or /task_notes.json
  def index
    @task_notes = TaskNote.all
  end

  # GET /task_notes/1 or /task_notes/1.json
  def show
  end

  # GET /task_notes/new
  def new
    @task_note = TaskNote.new
  end

  # GET /task_notes/1/edit
  def edit
  end

  # POST /task_notes or /task_notes.json
  def create
    @task_note = TaskNote.new(task_note_params)

    respond_to do |format|
      if @task_note.save
        format.html { redirect_to @task_note, notice: "Task note was successfully created." }
        format.json { render :show, status: :created, location: @task_note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_notes/1 or /task_notes/1.json
  def update
    respond_to do |format|
      if @task_note.update(task_note_params)
        format.html { redirect_to @task_note, notice: "Task note was successfully updated." }
        format.json { render :show, status: :ok, location: @task_note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_notes/1 or /task_notes/1.json
  def destroy
    @task_note.destroy!

    respond_to do |format|
      format.html { redirect_to task_notes_path, status: :see_other, notice: "Task note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_note
      @task_note = TaskNote.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_note_params
      params.expect(task_note: [ :title, :description, :task_id ])
    end
end
