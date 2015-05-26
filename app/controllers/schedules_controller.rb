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
    @applicant = Applicant.find(@schedule.applicant_id)
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

      @schedule = Schedule.new(params[:schedule])

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
        if !has_schedule.blank?
          has_schedule.destroy
        end
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
end
