class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  require 'json'

  protected
    def authorize
      if !File.exists?("#{RAILS_ROOT}/public/status.json")
        data = [{}]
        File.new "#{RAILS_ROOT}/public/status.json", "w+"
        File.open("#{RAILS_ROOT}/public/status.json", "w+") do |f|
          f.write(JSON.generate(data))
        end
        redirect_to wizard_path
      else
        if !File.exists?("#{RAILS_ROOT}/public/done.txt")
          file = File.read("#{RAILS_ROOT}/public/status.json")
          data = JSON.parse(file)
          if !data[0].has_key?("admin")
            redirect_to wizard_path(:current => "admin")
          elsif !data[0].has_key?("dept")
            redirect_to wizard_path(:current => "dept")
          elsif !data[0].has_key?("position")
            redirect_to wizard_path(:current => "pos")
          end
        else
          unless Admin.find_by_id(session[:admin_id])
            redirect_to login_url, :notice => "Please Login"
          else
            @admin = Admin.find(session[:admin_id])
          end
        end
      end
    end
end
