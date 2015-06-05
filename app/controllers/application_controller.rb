class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  protected
    def authorize
      if !File.exists?("#{RAILS_ROOT}/public/status.txt")
        redirect_to wizard_path
      else
        unless Admin.find_by_id(session[:admin_id])
          redirect_to login_url, :notice => "Please Login"
        else
          @admin = Admin.find(session[:admin_id])
        end
      end
    end
end
