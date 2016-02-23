class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :destroy]

  # GET /admin/users
  # GET /admin/users.json
  def index
    @submitted_users = User.select(&:submitted?)
    @ready_users = User.select(&:ready_to_submit?).reject(&:submitted?)
    @unready_users = User.select(&:not_submitted?).reject(&:ready_to_submit?)
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
