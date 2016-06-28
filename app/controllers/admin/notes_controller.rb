class Admin::NotesController < Admin::BaseController
  before_action :set_claim
  
  # GET /admin/claims/1/notes
  def index
    @notes = @claim.notes.sort_by(&:created_at)
  end

  private
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def note_params
  end
end
