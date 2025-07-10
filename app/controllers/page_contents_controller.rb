class PageContentsController < ApplicationController
  before_action :set_page_content, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[ about services portfolio contact home ]

  # GET /page_contents or /page_contents.json
  def index
    @page_contents = PageContent.all
  end

  # GET /page_contents/1 or /page_contents/1.json
  def show
  end

  # GET /page_contents/new
  def new
    @page_content = PageContent.new
  end

  # GET /page_contents/1/edit
  def edit
  end

  # POST /page_contents or /page_contents.json
  def create
    @page_content = PageContent.new(page_content_params)

    respond_to do |format|
      if @page_content.save
        format.html { redirect_to @page_content, notice: "Page content was successfully created." }
        format.json { render :show, status: :created, location: @page_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_contents/1 or /page_contents/1.json
  def update
    respond_to do |format|
      if @page_content.update(page_content_params)
        format.html { redirect_to @page_content, notice: "Page content was successfully updated." }
        format.json { render :show, status: :ok, location: @page_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_contents/1 or /page_contents/1.json
  def destroy
    @page_content.destroy!

    respond_to do |format|
      format.html { redirect_to page_contents_path, status: :see_other, notice: "Page content was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def about
    @page_content = PageContent.find_by_title("about")
    render template: "page_contents/show"
  end

  def services
    @page_content = PageContent.find_by_title("services")
    render template: "page_contents/show"
  end

  def portfolio
    @page_content = PageContent.find_by_title("portfolio")
    render template: "page_contents/show"
  end

  def contact
    @page_content = PageContent.find_by_title("contact")
    render template: "page_contents/show"
  end

  def home
    @page_content = PageContent.find_by_title("home")
    render template: "page_contents/show"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_content
      @page_content = PageContent.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def page_content_params
      params.expect(page_content: [ :title, :copy ])
    end
end
