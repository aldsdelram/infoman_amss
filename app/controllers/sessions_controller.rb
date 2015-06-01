class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
    session[:logged] = true
    if Admin.find_by_id(session[:admin_id])
        redirect_to index_url
    end
  end

  def create
    if user = Admin.authenticate(params[:name], params[:password])
        session[:admin_id] = user.id
        Dir.chdir(Rails.root.to_s+'/public/images/')
        Dir.mkdir('upload_images') unless Dir.exists?('upload_images')
        Dir.chdir(Rails.root.to_s+'/public/images/upload_images')
        Dir.mkdir('admins') unless Dir.exists?('admins')
        Dir.mkdir('applicants') unless Dir.exists?('applicants')
        Dir.mkdir('interviewers') unless Dir.exists?('interviewers')
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
