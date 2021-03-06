class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.paginate page: params[:page]
  end

  def show
    unless @user.activated
      flash[:error] = t "account-not-activated"
      redirect_to root_url
    end
    @microposts = @user.microposts.order_by_created_at.paginate page: params[:page]
    @follow = current_user.active_relationships.build
    @unfollow = current_user.active_relationships.find_by followed_id: @user.id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "please-check-email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_path unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:warning] = t "user_not_found"
      redirect_to root_path
    end
  end
end
