class AdminsController < ApplicationController
  include AdminsHelper
  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.xml
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])
    @image_data = params[:base64]
    file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}.png"
    @admin.image_name = "upload_images/admins/"+file_name


    respond_to do |format|
      if @admin.save
        upload_image(file_name, params[:base64])
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Created a new administrator -> "+@admin.id.to_s)
        format.html { redirect_to(admins_url, :notice => "Admin #{@admin.name} was successfully created.") }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:id])
    if !@admin.image_name.nil?
      file_name = @admin.image_name.split('/').last
    else
      file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}.png"
    end

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        if @admin.image_name != params[:imgName]
          upload_image(file_name, params[:base64])
        end
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Edited info of administrator -> "+@admin.id.to_s)
        format.html { redirect_to(admins_url, :notice => "Admin #{@admin.name}was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    if File.exists?("#{RAILS_ROOT}/public/images/#{@admin.image_name}") && !@admin.image_name.nil?
      File.delete("#{RAILS_ROOT}/public/images/#{@admin.image_name}")
    end
    AdminLog.create(:admin_id=>session[:admin_id], :log=>"Removed administrator -> "+@admin.id.to_s)
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end

  def show_logs
    @logs = AdminLog.where("admin_id = ?", params[:id])
    @admin = Admin.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @logs }
    end
  end
end
