class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = Note.all
	  @category_list = NoteCategory.alpha_ordered.all
    @categories = NoteCategory.single(params[:cat_id]).all

    if params[:search].present?
      @notes = @notes.where("title LIKE ? OR note LIKE ?", 
          "%#{params[:search]}%", "%#{params[:search]}%")
      end

    # Handle Turbo Stream requests for real-time updates
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
		@categories = NoteCategory.alpha_ordered.all
  end

  # GET /notes/1/edit
  def edit
		@categories = NoteCategory.alpha_ordered.all
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    checked_params = params[:category_list] || []
    for check_box_id in checked_params
    category = NoteCategory.find(check_box_id)
      unless @note.note_categories.include?(category)
        @note.note_categories << category
      end
    end

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    @note = Note.find(params[:id])
    @categories = NoteCategory.all
    checked_categories = []
    checked_params = params[:category_list] || []
    for check_box_id in checked_params
    category = NoteCategory.find(check_box_id)
      unless @note.note_categories.include?(category)
        @note.note_categories << category
      end
      checked_categories << category
    end
    missing_categories = @categories - checked_categories
    for category in missing_categories
      if @note.note_categories.include?(category)
        @note.note_categories.delete(category)
      end
    end
    
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to notes_path, status: :see_other, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :title, :note, :position ])
    end
end
