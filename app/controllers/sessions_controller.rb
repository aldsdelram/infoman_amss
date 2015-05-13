class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
    if Admin.find_by_id(session[:admin_id])
        redirect_to index_url
    end
  end

  def create
    if user = Admin.authenticate(params[:name], params[:password])
        session[:admin_id] = user.id
        redirect_to index_url
    else
        redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    if request.xhr?
      session[:admin_id] = nil

    else
      session[:admin_id] = nil
      redirect_to login_url
    end
  end
end
