class ApplicantsController < ApplicationController
  # GET /applicants
  # GET /applicants.xml
  def index
    @applicant = Applicant.last

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applicants }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.xml
  def show
    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.xml
  def show_all
    @applicants = Applicant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applicants }
    end
  end

  # GET /applicants/new
  # GET /applicants/new.xml
  def new
    @applicant = Applicant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  # GET /applicants/1/edit
  def edit
    @applicant = Applicant.find(params[:id])
  end

  # POST /applicants
  # POST /applicants.xml
  def create
    @applicant = Applicant.new(params[:applicant])
    @applicant.status = 'Pending'
    @applicant.image_name =  upload_image(params[:applicant][:image], params[:base64])

    respond_to do |format|
      if @applicant.save
        format.html { redirect_to(@applicant, :notice => 'Applicant ' +
                    @applicant.firstname + ' was successfully created.') }
        format.xml  { render :xml => @applicant, :status => :created, :location => @applicant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /applicants/1
  # PUT /applicants/1.xml
  def update
    @applicant = Applicant.find(params[:id])
    if @applicant.image_name != params[:imgName]
      if File.exists?("#{RAILS_ROOT}/public/images/#{@applicant.image_name}")
        File.delete("#{RAILS_ROOT}/public/images/#{@applicant.image_name}")
      end
      @applicant.image_name =  upload_image(params[:applicant][:image], params[:base64])
    end

    respond_to do |format|
      if @applicant.update_attributes(params[:applicant])
        format.html { redirect_to(@applicant, :notice => 'Applicant was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.xml
  def destroy
    puts "destroy"
    @applicant = Applicant.find(params[:id])
    if File.exists?("#{RAILS_ROOT}/public/images/#{@applicant.image_name}")
      File.delete("#{RAILS_ROOT}/public/images/#{@applicant.image_name}")
    end
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to(applicants_show_all_url) }
      format.xml  { head :ok }
    end
  end

  def search_applicant
    @search = []
    @search_type = ""

    #custom search
    if params[:custom] == "SEARCH"
      @category = params[:category]
      if !params[:search_query].blank?
        if !@category.blank?
          case @category
            when "FIRSTNAME"
              @search = Applicant.find(:all, :conditions => ["firstname LIKE ?", "%#{params[:search_query]}%"])
            when "LASTNAME"
              @search = Applicant.find(:all, :conditions => ["lastname LIKE ?", "%#{params[:search_query]}%"])
            when "SCHOOL"
              @search = Applicant.find(:all, :conditions => ["highest_school_attainment LIKE ?",
               "%#{params[:search_query]}%"])
          end
          @search_type = @category+" SEARCH RESULTS"
        else
          flash.now[:notice] = 'Please specify search menu'
        end
      else
        flash.now[:notice] = 'Please input search query'
      end
    #end_custom search
    #by_date search
    elsif params[:by_date] == "SEARCH"
      @search_type = "SEARCH BY DATE RESULTS"
      start_date = params[:start_date]
      end_date = params[:end_date]
      start_date = Date.parse(start_date[:year]+'-'+start_date[:month]+'-'+start_date[:day])
      end_date = Date.parse(end_date[:year]+'-'+end_date[:month]+'-'+end_date[:day])
      # if start_date > end_date
      #   temp = start_date
      #   start_date = end_date
      #   end_date = temp
      # end
      @search = Applicant.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
    end
    #end by_date
    respond_to do |format|
      format.html { render :action => 'search_applicant' }
    end
  end

  def header_search
    @search = Applicant.find(:all, :conditions => ["firstname LIKE ? OR lastname LIKE ? OR middlename LIKE ?",
     "%#{params[:applicant_name]}%", "%#{params[:applicant_name]}%", "%#{params[:applicant_name]}%"] )

    respond_to do |format|
      format.html { render :action => 'header_search' }
    end
  end

  def upload_image(image, base64)
    require 'fileutils'
    data =  base64
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])

    file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}."+image.content_type.split('/').last
    file_path = File.join(Rails.root, 'public', 'images', 'upload_images', file_name)
    File.open(file_path, 'wb') do |f|
      f.write image_data
    end
    return "upload_images/"+file_name
  end

end

