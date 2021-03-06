class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def logout!
    if !current_user.nil?
      current_user.reset_session_token!
    end

    session[:session_token] = nil
  end

  def require_user
    if current_user.nil?
      flash[:errors] = ["Please log in."]
      redirect_to new_session_url
    end
  end

  def require_moderator
    if current_user.id != Sub.find(params[:id]).moderator_id
      flash[:errors] = ["You can't delete sub"]
      redirect_to user_url(current_user)
    end
  end

  def require_author
    if current_user.id != Post.find(params[:id]).author.id
      flash[:errors] = ["You can't write a post for someone else!"]
      redirect_to user_url(current_user)
    end
  end
end
