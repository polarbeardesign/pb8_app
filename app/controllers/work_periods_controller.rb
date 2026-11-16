class WorkPeriodsController < ApplicationController
  before_action :set_work_period, only: %i[ show edit update destroy ]

  # GET /work_periods or /work_periods.json
  def index
    @per_page = 50
    @page = [ params[:page].to_i, 1 ].max
    @total_count = WorkPeriod.count
    @total_pages = [ (@total_count / @per_page.to_f).ceil, 1 ].max
    @work_periods = WorkPeriod.time_desc.includes(task: :customer)
                              .offset((@page - 1) * @per_page).limit(@per_page).to_a
    # consecutive rows sharing a Sunday-based week number (%U) form a group
    @weeks = @work_periods.chunk { |wp| wp.start_time.strftime("%Y-%U") }.map(&:last)
  end

  # GET /weekly_summary
  def weekly_summary
    @since = DateTime.now.beginning_of_week - 1.day
    @work_periods = WorkPeriod.weekly
    @tasks = Task.weekly.includes(:customer).to_a
    @customer_groups = @tasks.group_by(&:customer).sort_by { |customer, _| customer.org_name.to_s.downcase }
    @total_hours = @tasks.sum { |t| t.hour_tot.to_f }
    @total_billable = @tasks.sum { |t| t.bill_tot.to_f }
    @avg_minutes = @work_periods.size > 0 ? (@total_hours * 60) / @work_periods.size : nil
    @chart_rows = @tasks.map { |t| [ "#{t.customer.short_name} - #{t.task_name}", t.hour_tot.to_f.round(2) ] }
    @current_period = WorkPeriod.current_job.includes(:task).first
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
        # format.html { redirect_to @work_period, notice: "Work period was successfully created." }
        format.html { redirect_to task_path(@work_period.task_id), notice: "Work period was successfully created [start]." }

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
        # format.html { redirect_to @work_period, notice: "Work period was successfully updated." }
        format.html { redirect_to task_path(@work_period.task_id), notice: "Work period was successfully updated." }
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
