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
end
