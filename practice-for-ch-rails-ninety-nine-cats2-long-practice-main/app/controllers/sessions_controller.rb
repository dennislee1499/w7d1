class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username]
      params[:user][:password]
    )
    session[:session_token] = @user.reset_session_token!
    redirect_to cats_url
  end

  def destroy

  end

end
