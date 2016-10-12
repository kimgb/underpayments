class Admin::DocumentsController < Admin::BaseController
  before_action :set_document, except: [:new, :create]
  before_action :set_claim, only: [:new, :create]
  # GET /documents/1
  def show
  end
  
  # GET /admin/claims/1/documents/new
  def new
    @document = Document.new
  end
  
  # POST /admin/claims/1/documents
  def create
    @document = @claim.documents.build(document_params)
    @document.evidence = document_params[:evidence]

    respond_to do |format|
      if @claim.save
        format.html do 
          if params[:repeat]
            redirect_to new_admin_claim_document_path(coverage_start_date: @document.coverage_end_date + 1.day, coverage_end_date: @document.coverage_end_date + 7.days)
          else redirect_to [:admin, @claim], notice: 'Document was successfully uploaded.' end
        end
        format.json { render :show, status: :created, location: @claim.user }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /documents/1/edit
  def edit
  end
  
  # PATCH/PUT /documents/1
  def update
    respond_to do |format|
      if @document.update_attributes(document_params)
        format.html { redirect_to [:admin, @document.claim], notice: 'Document was updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @document.claim], notice: 'Document was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:evidence, :statement, :wage_evidence, :wages, :time_evidence, :hours, :coverage_start_date, :coverage_end_date)
  end
end
