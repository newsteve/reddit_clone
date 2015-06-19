class SessionsController < ApplicationController

  def create
    user = User.find_by_credentials(
          params[:user][:email],
          params[:user][:password]
          )

    if user.nil?
      render :new
    else
      login_user!(user)
      redirect_to user_url(user)
    end
  end

  def new
    @user = User.new
    render :new
  end

end
