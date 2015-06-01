class HomeController < ApplicationController
  skip_before_filter :authorize
  def index
    unless Admin.find_by_id(session[:admin_id])
      redirect_to login_url
    else
      @admin = Admin.find(session[:admin_id])

      @applicants = Applicant.all;
      @pending = Applicant.where(:status=> "Pending");
      @hired = Applicant.where(:status=> "Hired");
      @failed = Applicant.where(:status=> "Failed-Exam");

    end
  end

end
