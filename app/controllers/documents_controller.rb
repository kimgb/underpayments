class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :destroy]
  before_action :set_claim, only: [:new, :create]

  # GET /documents
  def index
    # TODO scope to claim
    @documents = Document.all
  end

  # GET /documents/1
  def show
  end

  # GET /claims/1/documents/new
  def new
    @document = Document.new
  end

  # POST /claims/1/documents/new
  # POST /claims/1/documents/new.json
  def create
    @document = @claim.documents.build
    @document.file = document_params[:file]

    respond_to do |format|
      if @document.save
        format.html { redirect_to @claim.user, notice: 'Document was successfully uploaded.' }
        format.json { render :show, status: :created, location: @claim.user }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to @document.claim.user, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_document
    @document = Document.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def document_params
    params.require(:document).permit(:file)
  end
end
