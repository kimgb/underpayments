class Admin::NotesController < Admin::BaseController
  before_action :set_annotatable

  # GET /admin/claims/1/notes
  def index
    @notes = @annotatable.notes.sort_by(&:created_at)
  end

  private
  def set_annotatable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return @annotatable = $1.classify.constantize.find(value)
      end
    end
    # @claim = Claim.find(params[:claim_id])
  end

  def note_params
  end
end
