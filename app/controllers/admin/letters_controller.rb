class Admin::LettersController < Admin::BaseController
  before_action :set_claim, only: [:index, :new, :create]
  before_action :set_letter, except: [:index, :new, :create]
  
  # GET /admin/claims/1/letters
  def index
    @letters = @claim.letters
  end

  # GET /admin/letters/1
  def show
    @print = params[:print] == "1"
    
    render @print ? :print : :show, layout: !@print
  end
  
  # GET /admin/claims/1/letters/new
  def new
    @letter = @claim.letters.build
  end

  # POST /admin/claims/1/letters
  def create
    @letter = @claim.letters.build(letter_params)
    @letter.write_body!
    
    respond_to do |format|
      if @letter.save
        format.html { redirect_to [:admin, @letter], notice: "Letter created." }
        format.json { render :show, status: :created, location: @letter }
      else
        format.html { render :new }
        format.json { render json: @letter.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /admin/letters/1/edit
  def edit
  end
  
  # PATCH/PUT /admin/letters/1
  def update
    respond_to do |format|
      if @letter.update(letter_params)
        format.html { redirect_to [:admin, @letter], notice: "Letter updated." }
        format.json { render :show, status: :updated, location: @letter }
      else
        format.html { render :edit }
        format.json { render json: @letter.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /admin/letters/1/file
  def file
    if @letter.sent?
      redirect_to [:admin, @letter], notice: "This letter has already been filed and marked sent."
    else
      if @letter.update(sent: true)
        UserMailer.file_letter(current_user.email, @letter).deliver_later
        redirect_to [:admin, @letter], notice: "Letter has been filed."
      else
        redirect_to [:admin, @letter], notice: "There was an error filing the letter."
      end
    end
  end
  
  # DELETE /admin/letters/1
  def destroy
    @letter.destroy
    respond_to do |format|
      format.html { redirect_to admin_claim_letters_path(@letter.claim), notice: "Letter removed." }
      format.json { head :no_content }
    end
  end

  private
  def set_letter
    @letter = Letter.find(params[:id])
  end
  
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def letter_params
    params.require(:letter).permit(:claim_id, :sent_on, :addressee, :address_id, :body, :contact_inbox, :signature)
  end
end
