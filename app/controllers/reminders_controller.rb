class RemindersController < ApplicationController
  before_action :set_reminder, only: %i[ show edit update destroy ]

  # GET /reminders or /reminders.json
  def index
    @reminders = Reminder.all
    @open_reminders = Reminder.active.includes(:work_periods, task: :customer).by_importance
    @done_reminders = Reminder.recently_done.includes(task: :customer)
    @active_task_ids = WorkPeriod.current_job.pluck(:task_id)
  end

  # GET /reminders/1 or /reminders/1.json
  def show
    @active_task_ids = WorkPeriod.current_job.pluck(:task_id)
    @work_periods = @reminder.work_periods.with_attached_files.time_desc.to_a
    @siblings = Reminder.active.where(task_id: @reminder.task_id).where.not(id: @reminder.id).by_importance
  end

  # GET /reminders/new
  def new
    @reminder = Reminder.new
  end

  # GET /reminders/1/edit
  def edit
  end

  # POST /reminders or /reminders.json
  def create
    @reminder = Reminder.new(reminder_params)

    respond_to do |format|
      if @reminder.save
        format.html { redirect_to @reminder, notice: "Reminder was successfully created." }
        format.json { render :show, status: :created, location: @reminder }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reminders/1 or /reminders/1.json
  def update
    respond_to do |format|
      if @reminder.update(reminder_params)
        # inline edits (complete toggle, importance select) go back to the list
        format.html { redirect_to(params[:inline] ? reminders_path : @reminder, status: :see_other, notice: "Reminder was successfully updated.") }
        format.json { render :show, status: :ok, location: @reminder }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1 or /reminders/1.json
  def destroy
    @reminder.destroy!

    respond_to do |format|
      format.html { redirect_to reminders_path, status: :see_other, notice: "Reminder was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reminder
      @reminder = Reminder.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def reminder_params
      params.expect(reminder: [ :title, :description, :completed, :time_critical, :task_id, :reminder_date, :due, :change_count, :position, :importance, :estimate_hours, :recurrence ])
    end
end
