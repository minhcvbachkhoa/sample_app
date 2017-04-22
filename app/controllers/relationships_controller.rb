class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :index

  def index
    @title = params[:title]
    follow = ["following", "followers"]
    if follow.exclude? @title
      flash[:error] = t "link-error"
      redirect_to @user
    else
      @users = @user.send(@title).paginate page: params[:page]
      render "users/show_follow"
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
      @unfollow = current_user.active_relationships.find_by followed_id: @user.id
    else
      flash[:error] = t "user_not_found"
      redirect_to root_url
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
      @follow = current_user.active_relationships.build
    else
      flash[:error] = t "user_not_found"
      redirect_to root_url
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:error] = t "user_not_found"
      redirect_to root_path
    end
  end
end
