class ExamsController < ApplicationController

  $per_page = 10 

  # GET /exams
  # GET /exams.xml
  def index
    puts "per page =====> " + @per_page.to_s
    #@exams = Exam.all
    @exams = Exam.paginate(
        :page=>params[:page],
        :order=>"title asc",
        :per_page=> $per_page
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
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Created new exam -> "+@exam.id.to_s)
        # page = Exam.all(:order => "title").index(@exam) / $per_page
        # page += 1
        page = find_page(@exam)

        format.html { redirect_to(exams_path(:page=> page), :notice => 'Exam was successfully created.') }
        format.xml  { render :xml => exams_url, :status => :created, :location => @exam }
      else
         @exams = Exam.paginate(
          :page=>params[:page],
          :order=>"title asc",
          :per_page=> $per_page
          )
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
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Updated a exam -> "+@edit_exam.id.to_s)
        
        page = find_page(@edit_exam)


        format.html { redirect_to(exams_path(:page=>page), :notice => 'Exam was successfully updated.') }
        format.xml  { head :ok }
      else
          @exams = Exam.paginate(
          :page=>params[:page],
          :order=>"title asc",
          :per_page=> $per_page
          )
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
    AdminLog.create(:admin_id=>session[:admin_id], :log=>"Removed a exam -> "+@exam.id.to_s)
    @exam.destroy
    
    respond_to do |format|
      format.html { redirect_to(exams_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_page(object)
    page = Exam.all(:order => "title").index(object) / $per_page
    page += 1
    page
  end
end
