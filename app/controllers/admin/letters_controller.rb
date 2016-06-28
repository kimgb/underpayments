class Admin::LettersController < Admin::BaseController
  before_action :set_claim

  # GET /admin/users/1/letters/new
  def new
    @letter = Letter.new
  end

  # POST /admin/users/1/letters
  def create
    @letter = Letter.new(letter_params)
    @address = (Company.find_by_name(@letter.addressee) || Company.find_by_contact(@letter.addressee))
    
    render :show, layout: false
  end
  
  def show
  end

  private
  def set_claim
    @claim = Claim.find(params[:claim_id])
    @user = @claim.user
  end

  def letter_params
    params.require(:letter).permit(:addressee, :contact_inbox, :signature)
  end
end
