class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  protected
    def authorize
      unless Admin.find_by_id(session[:admin_id])
        redirect_to login_url, :notice => "Please Login"
      end
    end
end
