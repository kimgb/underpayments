class Admin::DocumentsController < Admin::BaseController
  before_action :set_document
  # GET /documents/1
  def show
  end
  
  # GET /documents/1/edit
  def edit
  end
  
  # PATCH/PUT /documents/1
  def update
    respond_to do |format|
      if @document.update_attributes(document_params)
        format.html { redirect_to admin_user_path(@document.owners.first), notice: 'Document was updated.' }
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
      format.html { redirect_to admin_user_path(@document.owners.first), notice: 'Document was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:evidence, :statement, :wage_evidence, :wages, :time_evidence, :hours, :coverage_start_date, :coverage_end_date)
  end
end
