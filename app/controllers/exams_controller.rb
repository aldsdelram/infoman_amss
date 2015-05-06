class ExamsController < ApplicationController
  # GET /exams
  # GET /exams.xml
  def index
    #@exams = Exam.all
    @exams = Exam.paginate(
        :page=>params[:page],
        :order=>"title asc",
        :per_page=> 2
      )
    @new_exam = Exam.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exams }
    end
  end

  # GET /exams/1
  # GET /exams/1.xml
  def show
    @exam = Exam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exam }
    end
  end

  # GET /exams/new
  # GET /exams/new.xml
  def new
    @exam = Exam.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exam }
    end
  end

  # GET /exams/1/edit
  def edit
    @exam = Exam.find(params[:id])
  end

  # POST /exams
  # POST /exams.xml
  def create
    @exam = Exam.new(params[:exam])

    respond_to do |format|
      if @exam.save
        format.html { redirect_to(exams_url, :notice => 'Exam was successfully created.') }
        format.xml  { render :xml => exams_url, :status => :created, :location => @exam }
      else
        @exams = Exam.all
        @new_exam = @exam.clone
        format.html { render :action => "index" }
        format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /exams/1
  # PUT /exams/1.xml
  def update
    @edit_exam = Exam.find(params[:id])

    respond_to do |format|
      if @edit_exam.update_attributes(params[:exam])
        @edit_error = nil
        session['updated'] = @edit_exam
        format.html { redirect_to(exams_url, :notice => 'Exam was successfully updated.') }
        format.xml  { head :ok }
      else
        @exams = Exam.all
        @new_exam = Exam.new

        @edit_error = @edit_exam.clone
        format.html { render :action => "index" }
        #format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.xml
  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy

    respond_to do |format|
      format.html { redirect_to(exams_url) }
      format.xml  { head :ok }
    end
  end
end
