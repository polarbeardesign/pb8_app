class WorkPeriodsController < ApplicationController
  before_action :set_work_period, only: %i[ show edit update destroy ]

  # GET /work_periods or /work_periods.json
  def index
    @work_periods = WorkPeriod.all
  end

  # GET /work_periods/1 or /work_periods/1.json
  def show
  end

  # GET /work_periods/new
  def new
    @work_period = WorkPeriod.new
  end

  # GET /work_periods/1/edit
  def edit
  end

  # POST /work_periods or /work_periods.json
  def create
    @work_period = WorkPeriod.new(work_period_params)

    respond_to do |format|
      if @work_period.save
#        format.html { redirect_to @work_period, notice: "Work period was successfully created." }
        format.html { redirect_to task_path(@work_period.task_id), :notice => 'Work period was successfully created [start].' }

        format.json { render :show, status: :created, location: @work_period }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @work_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_periods/1 or /work_periods/1.json
  def update
    respond_to do |format|
      if @work_period.update(work_period_params)
#        format.html { redirect_to @work_period, notice: "Work period was successfully updated." }
        format.html { redirect_to task_path, :notice => 'Work period was successfully updated [end].' }
        format.json { render :show, status: :ok, location: @work_period }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @work_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_periods/1 or /work_periods/1.json
  def destroy
    @work_period.destroy!

    respond_to do |format|
      format.html { redirect_to work_periods_path, status: :see_other, notice: "Work period was successfully destroyed." }
      format.json { head :no_content }
    end
  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_period
      @work_period = WorkPeriod.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def work_period_params
      params.expect(work_period: [ :end_time, :start_time, :time_note, :billable, :task_id ])
    end
end
