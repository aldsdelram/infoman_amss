class SchedulesController < ApplicationController
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
    sched_time = @applicant.schedule.sched.to_s.split(' ')[1].split(':')
    if sched_time[0].to_i >= 12
      @sched_time_p = sched_time[0]+':'+sched_time[1]+':'+sched_time[2]+' PM'
      if sched_time[0].to_i > 12
        sched_time[0] = (sched_time[0].to_i-12).to_s
        @sched_time_p = sched_time[0]+':'+sched_time[1]+':'+sched_time[2]+' PM'
      end
    else
      @sched_time_p = sched_time[0]+':'+sched_time[1]+':'+sched_time[2]+' AM'
    end

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
    @date_and_time = '%m-%d-%Y'
    time = ""
    if params[:sched_time] != ""
      time = params[:sched_time].to_s+':00'
    end
    begin
      date = DateTime.strptime(params[:schedule][:sched], @date_and_time).to_s.split('T')[0]
      DateTime.parse(date+' '+time+':00')
    rescue ArgumentError
      hasError = true;
    else
      params[:schedule][:sched] = DateTime.parse(date+' '+time+':00')
    end
   
    @schedule = Schedule.new(params[:schedule])
    @applicant = Applicant.find(params[:schedule][:applicant_id])

    if params[:schedule][:sched].to_s == ""
      @schedule.realNil = true
      @schedule.hasError = false
    elsif hasError
      @schedule.realNil = false
      @schedule.hasError = true
    else  
      @schedule.sched = params[:schedule][:sched]
      if !@applicant.schedule.nil?
        @applicant.schedule.destroy
      end
    end

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to(@applicant, :notice => 'Schedule was successfully created.') }
        format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        if !hasError
          @schedule.sched = @schedule.sched.strftime('%d-%m-%Y')
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
end
