class UsersController < ApplicationController
  # Make sure users are logged in before being able to access edit and update
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :make_admin, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :make_admin]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to SB CUERVOS!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile udpated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def make_admin
    index
    User.find(params[:id]).update_attribute(:admin, true)
    render 'index'
  end

  def destroy
    index
    @user = User.find(params[:id])
    if @user.admin?
      flash[:danger] = 'Cannot delete admin users'
    else
      @user.destroy
      flash[:success] = 'User deleted'
    end
    render 'index'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :picture, :admin)
  end

  # Before filters

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
