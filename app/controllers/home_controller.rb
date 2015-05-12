class HomeController < ApplicationController
  skip_before_filter :authorize
  def index
    unless Admin.find_by_id(session[:admin_id])
      redirect_to login_url
    end
  end

end
