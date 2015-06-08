class WizardController < ApplicationController
  include AdminsHelper
  skip_before_filter :authorize
  layout "wizard"

  def index
    @admin = Admin.new
  end

  def addAdmin
    if request.xhr?
      @admin = Admin.new(params[:admin])
      @image_data = params[:base64]


      file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}.png"
      @admin.image_name = "upload_images/admins/"+file_name

      respond_to do |format|
        data = [];
        if @admin.save
          upload_image(file_name, params[:base64])
          data << {"ok"=> true}
        else
          data << {"ok"=> false}
          data << @admin.errors
          data << {"errors" => @admin.errors.count}
        end

        format.js { render :json => data.to_json}
      end
    end
  end

  def addDept
    if request.xhr?
      @department = Department.new(params[:department])

      respond_to do |format|
        data = [];
        if @department.save
          data << {"ok"=> true}
        else
          data << {"ok"=> false}
          data << @department.errors
          data << {"errors" => @department.errors.count}
        end

        format.js { render :json => data.to_json}
      end
    end
  end

  def done
    file = File.read("#{RAILS_ROOT}/public/status.json")
    data = JSON.parse(file)
    if params[:data] == "admin"
      data[0][:admin] = true
    elsif params[:data] == "dept"
      data[0][:dept] = true
    end

      File.open("#{RAILS_ROOT}/public/status.json", "w+") do |f|
        f.write(JSON.generate(data))
      end
  end
end
