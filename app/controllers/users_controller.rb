class UsersController < ApplicationController
  before_action :require_admin, only: [:ban, :destroy, :resend_confirmation_instructions]
  before_action :require_admin_or_inviter, only: [:resend_invitaion]
  before_action :require_admin_or_owner, only: [:edit, :update]

  def index
    @users = User.all.order(created_at: :asc)
  end

  def show
    @user = User.find(params[:id])
  end

  def ban
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to @user, alert: "You Can Not Ban Yourself!!"
    else
      if @user.access_locked?
        @user.unlock_access!
      else
        @user.lock_access!
      end
      redirect_to @user, notice: "User Access Locked: #{@user.access_locked?} "
    end
  end

  def resend_confirmation_instructions
    @user = User.find(params[:id])
    if @user.confirmed? == false && @user.created_by_invite? == false
      @user.resend_confirmation_instructions
      redirect_to @user, notice: "Confirmation Instructions were resent!"
    else
      redirect_to @user, alert: "User Already Confirmed!"
    end
  end

  def resend_invitaion
    @user = User.find(params[:id])
    if @user.created_by_invite? && @user.invitation_accepted? == false && @user.confirmed? == false
      @user.invite!
      @user.resend_confirmation_instructions
      redirect_to @user, notice: "Invitaion were resent!"
    else
      redirect_to @user, alert: "User Already Confirmed!"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path, notice: "User was successfully Destroyed!"
    else
      redirect_to users_path, alert: "User has associations.cannot be destroyed!"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  private

  def user_params
    list_allowed_params = [:name] if current_user == @user || current_user.admin?
    list_allowed_params += [*User::ROLES] if current_user.admin?
    # params.require(:user).permit(*User::ROLES, :name)
    params.require(:user).permit(list_allowed_params)
  end

  def require_admin
    unless current_user.admin? || current_user.teacher?
      redirect_to root_path, alert: "You are not authorized to perform this role"
    end
  end

  def require_admin_or_inviter
    @user = User.find(params[:id])
    unless current_user.admin? || @user.invited_by == current_user
      redirect_to root_path, alert: "You are not authorized to perform this role"
    end
  end

  def require_admin_or_owner
    @user = User.find(params[:id])
    unless current_user.admin? || current_user == @user
      redirect_to root_path, alert: "You are not authorized to perform this role"
    end
  end

end
