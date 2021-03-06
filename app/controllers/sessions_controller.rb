class SessionsController < ApplicationController
  def new
  end

  def create
    # find user by email param
    @user = User.find_by(email: params[:session][:email].downcase)

    # if user is true and the password matches its authentication
    if @user && @user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page
      log_in @user
      # Remembers user if checks the 'remember_me' checkbox at login page
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      # Render login page with an error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
