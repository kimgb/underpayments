class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :destroy, :edit, :update]
  before_action :authorise_owner!, only: [:show, :destroy, :edit, :update]
  before_action :set_claim, only: [:new, :create]
  before_action :confirm_unlocked!, only: [:edit, :update, :destroy]

  # GET /documents
  # def index
  #   # TODO scope to claim
  #   @documents = Document.all
  # end

  # GET /documents/1
  def show
  end

  # GET /claims/1/documents/new
  def new
    if params[:affidavit]
      @document = Document.new(@claim.affidavit_generator)
    else
      @document = params[:document] ? Document.new(document_params) : Document.new
    end
  end

  # POST /claims/1/documents/new
  # POST /claims/1/documents/new.json
  def create
    @document = @claim.documents.build(document_params)
    @document.evidence = document_params[:evidence]

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
  
  # GET /documents/1/edit
  def edit
  end
  
  # PATCH/PUT /documents/1
  def update
    respond_to do |format|
      if @document.update_attributes(document_params)
        format.html { redirect_to @document, notice: 'Document was updated.' }
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
      format.html { redirect_to @document.claim.user, notice: 'Document was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  def authorise_owner!
    forbidden! unless current_user && current_user.owns?(@document)
  end
  
  def set_document
    @document = Document.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def document_params
    params.require(:document).permit(:evidence, :statement, :wage_evidence, :wages, :time_evidence, :hours, :coverage_start_date, :coverage_end_date)
  end
  
  def confirm_unlocked!
    claim = @document.claim
    
    forbidden! if (claim && claim.locked?) && !(current_user && current_user.admin?)
  end
end
