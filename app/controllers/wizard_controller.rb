class WizardController < ApplicationController
  include AdminsHelper
  skip_before_filter :authorize
  layout "wizard"

  def index
    @admin = Admin.new

    if File.exists?("#{RAILS_ROOT}/public/done.txt")
      redirect_to index_url
    end
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

  def addPos
    if request.xhr?
      @position = Position.new(params[:position])

      respond_to do |format|
        data = [];
        if @position.save
          data << {"ok"=> true}
        else
          data << {"ok"=> false}
          data << @position.errors
          data << {"errors" => @position.errors.count}
        end

        format.js { render :json => data.to_json}
      end
    end
  end

  def addExams
    if request.xhr?
      @exam = Exam.new(params[:exam])

      respond_to do |format|
        data = [];
        if @exam.save
          data << {"ok"=> true}
        else
          data << {"ok"=> false}
          data << @exam.errors
          data << {"errors" => @exam.errors.count}
        end

        format.js { render :json => data.to_json}
      end
    end
  end

  def done
    file = File.read("#{RAILS_ROOT}/public/status.json")
    data = JSON.parse(file)
    if params[:data] == "admin" && !data[0].has_key?("admin")
      data[0][:admin] = true
    elsif params[:data] == "dept" && !data[0].has_key?("dept")
      data[0][:dept] = true
    elsif params[:data] == "pos" && !data[0].has_key?("pos")
    data[0][:pos] = true
    elsif params[:data] == "exam" && !data[0].has_key?("exam")
    data[0][:exam] = true
    elsif params[:data] == "welc"
      File.new "#{RAILS_ROOT}/public/done.txt", "w+"
      File.open("#{RAILS_ROOT}/public/done.txt", "w+") do |f|
        f.write("done");
        f.close
      end
    end

      File.open("#{RAILS_ROOT}/public/status.json", "w+") do |f|
        f.write(JSON.generate(data))
      end
  end
end
