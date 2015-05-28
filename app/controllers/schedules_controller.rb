class SchedulesController < ApplicationController
  include SchedulesHelper
  # GET /schedules
  # GET /schedules.xml
  def index
    @schedules = Schedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.xml
  def show
    @schedule = Schedule.find(params[:id])
    sched_time_s = @schedule.sched_start.to_s.split(' ')[1].split(':')
    sched_time_e = @schedule.sched_end.to_s.split(' ')[1].split(':')

    @sched_time_start = determine_am_pm(sched_time_s)
    @sched_time_end = determine_am_pm(sched_time_e)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.xml
  def new

    @schedule = Schedule.new
    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/1/edit
  def edit
    @schedule = Schedule.find(params[:id])
  end

  # POST /schedules
  # POST /schedules.xml
  def create
    # start commit
    @applicant = Applicant.find(params[:schedule][:applicant_id])
    interviewer = Interviewer.find(params[:schedule][:interviewer_id])
    has_schedule = get_schedule(interviewer, @applicant.id)

    if params[:new_schedule] == 'Schedule' || params[:new_schedule] == 'Reschedule'

      if !params[:schedule][:sched_start].match('^\d{2}-\d{2}-\d{4}$')
          hasError = true;
      end

      @date_and_time = '%m-%d-%Y'
      time = ""
      if params[:sched_time_start] != "" && params[:sched_time_end] != ""
        time_start = params[:sched_time_start].to_s+':00'
        time_end = params[:sched_time_end].to_s+':00'
      end

      begin
        date = DateTime.strptime(params[:schedule][:sched_start], @date_and_time).to_s.split('T')[0]
        DateTime.parse(date+' '+time_start+':00')
        DateTime.parse(date+' '+time_end+':00')
      rescue ArgumentError
        hasError = true;
      else
        params[:schedule][:sched_start] = DateTime.parse(date+' '+time_start+':00')
        params[:schedule][:sched_end] = DateTime.parse(date+' '+time_end+':00')
      end

      if params[:new_schedule] == "Reschedule"
        @schedule = has_schedule
      else
        @schedule = Schedule.new(params[:schedule])
      end

      if params[:schedule][:sched_start].to_s == "" ||
        params[:schedule][:sched_end].to_s == ""
        @schedule.realNil = true
        @schedule.hasError = false
      end
      if hasError && params[:schedule][:sched_start].to_s != ""
        @schedule.realNil = false
        @schedule.hasError = true
      else
        @schedule.sched_start = params[:schedule][:sched_start]
        @schedule.sched_end = params[:schedule][:sched_end]

      end
    # end if commit

    elsif params[:cancel_schedule] == 'Cancel'
      has_schedule.destroy
    end

    respond_to do |format|
      if params[:cancel_schedule] == 'Cancel'
        format.html { redirect_to(schedules_new_path(@applicant), :notice => 'Schedule was successfully cancelled.') }
      elsif @schedule.save
        format.html { redirect_to(schedules_new_path(@applicant), :notice => 'Schedule was successfully created.') }
        format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        if !hasError
          @schedule.sched_start = @schedule.sched_start.strftime('%m-%d-%Y')
          @schedule.sched_end = @schedule.sched_end.strftime('%m-%d-%Y')
        end
      format.html { render :action => "new" }
      format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.xml
  def update
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        format.html { redirect_to(@schedule, :notice => 'Schedule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.xml
  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to(schedules_url) }
      format.xml  { head :ok }
    end
  end

  def getEvent
    @events = []
    @schedules = Schedule.all
    @schedules.each do |event|

      @applicant = event.applicant
      name = @applicant.firstname + ' ';
      name += (@applicant.middlename.first.upcase + '. ') unless @applicant.middlename.blank?
      name += @applicant.lastname
      event_json = {
        "id" => event.id,
        "start" => event.sched_start.to_datetime,
        "end" => event.sched_end.to_datetime,
        "title" => @applicant.firstname + ' ' + @applicant.lastname,
        "applicant" => name,
        "interviewer" => event.interviewer.name,
        "imgsrc" => @applicant.image_name
      }
      @events << event_json
    end

    respond_to do |format|
      format.js {render :json => @events.to_json} if request.xhr?
    end
  end

  def interviewer_grade_decision
    schedule = Schedule.find(params[:id])
    applicant = Applicant.find(schedule.applicant.id)

    case params[:trigger]
      when "For Hiring"
        schedule.grade = "PS"
        applicant.status = "For Hiring"
        applicant.save
      when "Passed"
        schedule.grade = "PA"
        applicant.status = "For Hiring"
        applicant.save
      when "Failed"
        schedule.grade = "FI"
        applicant.status = "For Hiring"
        applicant.save
      when "Failed-Stop", "Failed"
        schedule.grade = "FS"
        applicant.status = "For Hiring"
        applicant.save
      when "Passed-Continue"
        schedule.grade = "PC"
      when "Failed-Continue"
        schedule.grade = "FC"
    end

    schedule.remarks = params[:remarks]
    schedule.det = true
    
    if params[:trigger] == "For Hiring" || params[:trigger] == "Failed-Stop"

      applicant.schedules.where("grade IS NULL").each do |sched|
        sched.destroy
        puts "Schedule removed"
      end

      applicant.interviewers.each do |interviewer|
        if !interviewer.schedules.where("applicant_id = (?)", applicant.id).any?
          interviewer.applicants.delete(applicant)
          puts "Interviewer removed"
        end
      end
    end
    respond_to do |format|
      @schedule = schedule
      if schedule.save
        format.html {redirect_to @schedule, :notice=>'NOTICE' }
      else
        format.html {render :action => 'show', :notice=>'NOTICE' }
      end
    end
  end

  def per_applicant
    if params[:applicant_id]
      @search = Applicant.paginate(:conditions=>["id = ?", params[:applicant_id]], :page=>params[:page], :per_page=>1)
    elsif params[:query]
      @query = params[:query].gsub(/\s+/, ' ')

      @search = Applicant.paginate(:conditions=> ["CONCAT_WS(\' \',firstname,middlename,lastname) LIKE ?" +
        " OR CONCAT_WS(\' \',firstname,lastname) LIKE ?" , "%#{@query}%", "%#{@query}%"],
          :page=>params[:page],
          :order=>"lastname asc",
          :per_page=> 10
        )
    end
  end

  def per_interviewer
    if params[:query]
      @query = params[:query].gsub(/\s+/, ' ')

      @search = Interviewer.paginate(:conditions=> ["name LIKE ?", "%#{@query}%"],
          :page=>params[:page],
          :order=>"name asc",
          :per_page=> 10
        )
    end
  end

  def getSched
    if request.xhr?
      if params[:filter] == 'applicant'

        @applicant = Applicant.find(params[:applicant_id])


        @schedules = []
        @applicant.schedules.each do |sched|
          link = '---'
          link = "<a href='#{schedule_url(sched)}'>Grade</a>".html_safe if sched.grade.nil?

          @sched = {
            "date" => sched.sched_start.strftime('%B %d, %Y'),
            "time" => sched.sched_start.strftime('%H:%m %p') + '-' + sched.sched_end.strftime('%H:%m %p'),
            "interviewer" => sched.interviewer.name,
            "link" => link
          }
          @schedules << @sched
        end

      else

        @interviewer = Interviewer.find(params[:interviewer_id])


        @schedules = []
        @interviewer.schedules.each do |sched|

        applicant = sched.applicant
        name = applicant.firstname + ' ';
          unless applicant.middlename.blank?
                name += (applicant.middlename.first.upcase + '. ')
          end
        name += applicant.lastname
          link = '---'
          link = "<a href='#{schedule_url(sched)}'>Grade</a>".html_safe if sched.grade.nil?

          @sched = {
            "date" => sched.sched_start.strftime('%B %d, %Y'),
            "time" => sched.sched_start.strftime('%H:%m %p') + '-' + sched.sched_end.strftime('%H:%m %p'),
            "applicant" => name,
            "link" => link
          }
          @schedules << @sched
        end


      end

      respond_to do |format|
        format.js { render :json => @schedules.to_json}
      end

    end
  end
end
