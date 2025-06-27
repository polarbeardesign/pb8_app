class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.active.sorted
    @customers = Customer.weekly
#    @tasks = Task.weekly
    @work_periods = WorkPeriod.weekly
    @current_task = Task.current_task
    @today = Reminder.sorted.active.today.all
    @next = Reminder.sorted.active.next.all
    @someday = Reminder.sorted.active.someday.all
    @tasks_chart = Task.find_by_sql("SELECT tasks.task_name,customers.org_name,SUM(TIMESTAMPDIFF(SECOND,work_periods.start_time,work_periods.end_time))/3600 AS hour_tot FROM `tasks` INNER JOIN `work_periods` ON `work_periods`.`task_id` = `tasks`.`id` INNER JOIN `customers` ON `customers`.`id` = `tasks`.`customer_id` WHERE `tasks`.`customer_id` = 6 AND work_periods.end_time BETWEEN NOW() - INTERVAL 30 DAY AND NOW() GROUP BY tasks.task_name")


  end

  # GET /tasks/1 or /tasks/1.json
  def show
    @current = WorkPeriod.find_by_sql("SELECT work_periods.id FROM work_periods WHERE start_time = end_time AND task_id = '#{@task.id}' LIMIT 1")

    if !@current.blank?
      @work_period = WorkPeriod.find_by_id(@current.last.id)
#      commute = @work_period.build_commute
      @flag = "active_task"
    else
      @work_period = WorkPeriod.new
    end

  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.expect(task: [ :task_name, :description, :notes, :status, :due_date, :date_completed, :priority, :customer_id ])
    end
end
