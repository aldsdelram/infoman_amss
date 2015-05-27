class ApplicantsController < ApplicationController
  include ApplicantsHelper
  # GET /applicants
  # GET /applicants.xml

  def index
    @applicants = Applicant.all
    @datatable = ApplicantsIndex
    @latest_applicant = Applicant.last


     respond_to do |format|
      format.html # index.html.erb
      format.js { render :json => @datatable.query(params).to_json }
      format.xml  { render :xml => @applicants }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.xml
  def show
    @applicant = Applicant.find(params[:id])
    
    if @applicant.status != "Hired"
      @exam_list = @applicant.position.exams.where("exam_id NOT IN (" +
          "SELECT exam_id "+
          "FROM grades "+
          "WHERE applicant_id = ?)", @applicant)

      @interviewer_option = false
      if params[:bypass_exams]
        @applicant.exams.each do |exam|
          if exam.grades.find_by_applicant_id(@applicant).score.nil?
            @applicant.exams.delete(exam)
          end
        end
        @applicant.skipped_exam = 1
        @applicant.save
      end

      @taken_all_exam = true
      @applicant.exams.each do |exam|
        if exam.grades.find_by_applicant_id(@applicant).score.nil?
          @taken_all_exam = false
        end
        if !exam.grades.find_by_applicant_id(@applicant).score.nil?
          if exam.grades.find_by_applicant_id(@applicant).score.to_i < exam.passing_score
            @applicant.status = 'Failed'
            @applicant.save
          end
        end
      end
    end
    respond_to do |format|

    if params[:bypass_all] == 'Proceed to Interview'
      @applicant.skipped_exam = 1
      @applicant.save
      format.html {redirect_to applicants_assign_interviewer_path(@applicant)}
    elsif params[:consider_interview] == 'Consider for Interview'
      @applicant.consider = 1
      @applicant.save
      format.html {redirect_to applicants_assign_interviewer_path(@applicant)}
    elsif params[:HIRE]
      @applicant.status = "Hired"
      @applicant.save
      format.html {redirect_to @applicant}
    end
      format.html # show.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.xml
  def show_all
    @applicants = Applicant.all
    @toShow = params[:toShow]
    case @toShow
    	when "all"
    		@applicants = Applicant.all
    	when "pending"
    		@applicants = Applicant.find(:all, :conditions => ["status = 'Pending'"])
    	when "hired"
    		@applicants = Applicant.find(:all, :conditions => ["status = 'Hired'"])
    	when "failed"
    		@applicants = Applicant.find(:all, :conditions => ["status = 'Failed'"])
      when "on-interview"
        @applicants = Applicant.find(:all, :conditions => ["status = 'On-Interview'"])
      when "for-hiring"
        @applicants = Applicant.find(:all, :conditions => ["status = 'For Hiring'"])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applicants }
    end
  end

  # GET /applicants/new
  # GET /applicants/new.xml
  def new
    @applicant = Applicant.new
    @school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  # GET /applicants/1/edit
  def edit
    @applicant = Applicant.find(params[:id])
    @school = School.new
  end

  # POST /applicants
  # POST /applicants.xml
  def create
    if params[:consider] == 'Consider as NEW'
      @applicant = Applicant.new(session[:applicant].attributes)
      @applicant.school = School.find(session[:school_id])
    else
      params[:applicant][:firstname] = params[:applicant][:firstname].gsub(/\s+/, ' ')
      params[:applicant][:lastname] = params[:applicant][:lastname].gsub(/\s+/, ' ')
      params[:applicant][:middlename] = params[:applicant][:middlename].gsub(/\s+/, ' ')
      @applicant = Applicant.new(params[:applicant])
    end

    @create_school = nil
    @school = School.new
    @image_data = params[:base64]
    respond_to do |format|

      if params[:cancel] == "Cancel"
        @school = School.new
        format.html {render :action => "new" }
      elsif params[:new_school] == 'Create new school'
        @school = School.new
        @school.school_name = params[:school_name]
        @school.acronym = params[:acronym]

        if @school.save
          @create_school = "success";
          format.html {render :action => "new" }
          format.xml  { render :xml => @school, :status => :created, :location => @school }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
        end
      else
        matched_db_applicants = []
        if params[:consider] != 'Consider as NEW'
          @applicant.status = 'Pending'
          @applicant.skipped_exam = 0
          @applicant.consider = 0
          @applicant.image_name = upload_image(params[:applicant][:image], params[:base64])
          @applicant.school = School.find(params[:school_id])

          matched_db_applicants = validate_applicant_identity(params[:applicant])
        end

        if matched_db_applicants.any?
          begin
            params[:applicant][:image].tempfile = nil
          rescue

          end

          session[:matched] = matched_db_applicants
          session[:applicant] = @applicant
          session[:school_id] = params[:school_id]
          format.html{redirect_to(applicants_verify_path)}

        else
          if @applicant.save
            session[:applicant] = nil;
            session[:school_id] = nil;
            session[:matched] = nil;

            format.html { redirect_to(@applicant, :notice => 'Applicant ' +
                        @applicant.firstname + ' was successfully created.') }
            format.xml  { render :xml => @applicant, :status => :created, :location => @applicant }
          else
            @school_session = params[:school_id]
            format.html { render :action => "new" }
            format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
          end
        end

      end
    end
  end

  # PUT /applicants/1
  # PUT /applicants/1.xml
  def update
    @applicant = Applicant.find(params[:id])
    @create_school = nil
    respond_to do |format|
      if params[:cancel] == "Cancel"
          @school = School.new
          format.html {render :action => "new" }
      elsif params[:new_school] == 'Create new school'
          @school = School.new
          @school.school_name = params[:school_name]
          @school.acronym = params[:acronym]
          if @school.save
            @applicant.school = @school
            @create_school = "success";
            format.html {render :action => "new" }
            format.xml  { render :xml => @school, :status => :created, :location => @school }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
          end
      else
        if @applicant.image_name != params[:imgName]
          if File.exists?("#{RAILS_ROOT}/public/images/#{@applicant.image_name}")
            File.delete("#{RAILS_ROOT}/public/images/#{@applicant.image_name}")
          end
          @applicant.image_name =  upload_image(params[:applicant][:image], params[:base64])
        end
          @applicant.school = School.find(params[:school_id])

        if @applicant.update_attributes(params[:applicant])

          format.html { redirect_to(@applicant, :notice => 'Applicant was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
        end
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
            when '0'
              @search = Applicant.find(:all, :conditions => ["firstname LIKE ?", "%#{params[:search_query]}%"])
            when '1'
              @search = Applicant.find(:all, :conditions => ["lastname LIKE ?", "%#{params[:search_query]}%"])
            when '2'
              @search = Applicant.joins(:school).find(:all, :conditions => ["school_name LIKE ? OR acronym LIKE ?",
               "%#{params[:search_query]}%","%#{params[:search_query]}%"])
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
    @query = params[:applicant_name].gsub(/\s+/, ' ')

    @search = Applicant.paginate(:conditions=> ["CONCAT_WS(\' \',firstname,middlename,lastname) LIKE ?" +
      " OR CONCAT_WS(\' \',firstname,lastname) LIKE ?" , "%#{@query}%", "%#{@query}%"],
        :page=>params[:page],
        :order=>"lastname asc",
        :per_page=> 5
      )
    # @search = Applicant.find_by_sql(@sql)
    params[:applicant_name] = @query
    respond_to do |format|
      format.html { render :action => 'header_search' }
    end
  end

  def upload_image(image, base64)
    require 'fileutils'
    data =  base64
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])
    who = 'applicants'
    file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}.png"
    file_path = File.join(Rails.root, 'public', 'images', 'upload_images', who, file_name)
    File.open(file_path, 'wb') do |f|
      f.write image_data
    end
    return "upload_images/#{who}/"+file_name
  end

  def assign_interviewer
    require 'cgi'

    if params[:remove_interviewer] == 'Cancel'
      id = CGI::parse(params[:id])
      @applicant = Applicant.find(id['applicant'][0].to_i.to_s)
    else
      #raise "HELLo"
      @applicant = Applicant.find(params[:id])
    end
    respond_to do |format|
      if params[:commit]
        interviewer = Interviewer.where(name: "#{params[:interviewer]}").first
        interviewer.applicants << @applicant
        @applicant.status = 'On-Interview'
        @applicant.save
        format.html { redirect_to applicants_assign_interviewer_path(@applicant) }
      elsif params[:remove_interviewer] == 'Cancel'
        interviewer_remove = Interviewer.find(id['interviewer'][0].to_i)
        if @applicant.schedules.where('interviewer_id = ?', interviewer_remove.id).any?
          @applicant.schedules.where(['interviewer_id = ?', interviewer_remove.id]).first.destroy
        end
        interviewer_remove.applicants.delete(@applicant)
        format.html { redirect_to applicants_assign_interviewer_path(@applicant) }
      else
        format.html { render :action => 'assign_interviewer' }
      end
    end
  end

  def get_interviewer
  	if request.xhr?
  		@department_id = Department.find(:first, :conditions => ["department_name = ?", params[:department_name]]).id      
    	if !params[:selected_interviewers].blank?
        params[:selected_interviewers] = params[:selected_interviewers].map {|i| i.to_i}
        options = Interviewer.where("department_id = (?) AND id NOT IN (?)",
          @department_id, params[:selected_interviewers])
      else
        options = Interviewer.where("department_id = (?)", @department_id)
      end

      render :json => {
            :interviewers => options
						}
    end
  end

  def get_info
  	if request.xhr?
      info = Interviewer.where(name: "#{params[:name]}").first
      info.image_name = view_context.image_path(info.image_name)
    	render :json => {
						:info => info
						}
    end
  end

  def matched_db_applicants
    
    if params[:renew] == "true"
      
      matched_applicant = Applicant.find(params[:id])
      applicant = session[:applicant]      
      applicant.school = School.find(session[:school_id])

      session[:applicant] = nil;
      session[:school_id] = nil;
      session[:matched] = nil;

      if File.exists?("#{RAILS_ROOT}/public/images/#{matched_applicant.image_name}")
          File.delete("#{RAILS_ROOT}/public/images/#{matched_applicant.image_name}")
      end

      history = ApplicantReApplication.new(
        :applicant_id=>matched_applicant.id,
        :applied_for=>matched_applicant.position_id
        )

      if matched_applicant.update_attributes(applicant.attributes)
        
        if history.save
          matched_applicant.grades.each do |store|
            GradeHistory.create(
              :applicant_re_applications_id => history.id,
              :exam_id => store.exam_id,
              :score => store.score
              )
            store.destroy
          end
        end

        matched_applicant.interviewers.each do |rem|
          rem.applicants.delete(matched_applicant)
        end

        matched_applicant.schedules.each do |rem|
          rem.destroy
        end

        respond_to do |format|
          format.html { redirect_to(matched_applicant, :notice => 'Applicant was successfully updated.') }
          format.xml  { head :ok }
        end
      end
    else
      @applicant = Applicant.new
      @applicant_new = session[:applicant]
      @matched = session[:matched]
    end

  end

  def assign_grade
    @applicant = Applicant.find(params[:id])
    @exam = Exam.find(params[:exam])
    @applicant.exams << @exam

    redirect_to @applicant
  end

  def update_grade
    @applicant = Applicant.find(params[:id])
    @exam = Exam.find(params[:exam_id])
    @grade = @applicant.exams.find(@exam).grades.find_by_applicant_id(@applicant)

    @grades = Grade.find(@grade)
    @grades.update_attributes(params[:grade])
    respond_to do |format|
      if @grades.save
        format.html { redirect_to @applicant}
      else
        @applicant = Applicant.find(params[:id])
        @exam_list = @applicant.position.exams.where("exam_id NOT IN (" +
            "SELECT exam_id "+
            "FROM grades "+
            "WHERE applicant_id = ?)", @applicant)
        @edit_grade = @grades
        @edit_error = true
        format.html {render 'show'}
      end
    end
  end
end
