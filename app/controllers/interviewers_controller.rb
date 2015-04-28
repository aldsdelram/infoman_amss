class InterviewersController < ApplicationController
  # GET /interviewers
  # GET /interviewers.xml
  def index
    @interviewers = Interviewer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interviewers }
    end
  end

  # GET /interviewers/1
  # GET /interviewers/1.xml
  def show
    @interviewer = Interviewer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interviewer }
    end
  end

  # GET /interviewers/new
  # GET /interviewers/new.xml
  def new
    @interviewer = Interviewer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interviewer }
    end
  end

  # GET /interviewers/1/edit
  def edit
    @interviewer = Interviewer.find(params[:id])
  end

  # POST /interviewers
  # POST /interviewers.xml
  def create
    @interviewer = Interviewer.new(params[:interviewer])

    respond_to do |format|
      if @interviewer.save
        format.html { redirect_to(@interviewer, :notice => 'Interviewer was successfully created.') }
        format.xml  { render :xml => @interviewer, :status => :created, :location => @interviewer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interviewer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interviewers/1
  # PUT /interviewers/1.xml
  def update
    @interviewer = Interviewer.find(params[:id])

    respond_to do |format|
      if @interviewer.update_attributes(params[:interviewer])
        format.html { redirect_to(@interviewer, :notice => 'Interviewer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interviewer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interviewers/1
  # DELETE /interviewers/1.xml
  def destroy
    @interviewer = Interviewer.find(params[:id])
    @interviewer.destroy

    respond_to do |format|
      format.html { redirect_to(interviewers_url) }
      format.xml  { head :ok }
    end
  end
end
