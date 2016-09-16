class Admin::LettersController < Admin::BaseController
  before_action :set_claim

  # GET /admin/users/1/letters/new
  def new
    @letter = Letter.new
  end

  # POST /admin/users/1/letters
  def create
    @user = @claim.user
    @letter = Letter.new(letter_params)
    @letter.address = (
      Company.find_by_name(@letter.addressee).try(:address) || 
      CompanyContact.find_by_name(@letter.addressee).company.try(:address)
    )
    
    # If the admin wants to file a letter... (this approach renders an HTML string)
    # letter_content = render_to_string(template: "admin/letters/show", layout: false)
    # @claim.documents.create(
    #   coverage_start_date: @claim.employment_began_on, 
    #   coverage_end_date: @claim.employment_ended_on,
    #   statement: letter_content
    # )
    
    render :show, layout: false
  end
  
  def show
  end

  private
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def letter_params
    params.require(:letter).permit(:addressee, :contact_inbox, :signature)
  end
end
