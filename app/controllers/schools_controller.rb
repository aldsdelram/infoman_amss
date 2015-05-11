class SchoolsController < ApplicationController
  # GET /schools
  # GET /schools.xml 

  $per_page = 10

  def index
    @schools = School.paginate(
        :page=>params[:page],
        :order=>"school_name asc",
        :per_page=> $per_page
      )
    @new_school = School.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end

  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
  end

  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])

    respond_to do |format|
      if @school.save

        page = find_page(@school)

        format.html { redirect_to(@school, :notice => 'School was successfully created.') }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else

        @schools = School.paginate(
            :page=>params[:page],
            :order=>"school_name asc",
            :per_page=> $per_page
          )
        @new_school = @school.clone

        format.html { render :action => "index" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    @edit_school = School.find(params[:id])

    respond_to do |format|
      if @edit_school.update_attributes(params[:school])
        @edit_error = nil
        session['updated'] = @edit_exam

        page = find_page(@edit_exam)

        format.html { redirect_to(schools_path(:page=>page), :notice => 'School was successfully updated.') }
        format.xml  { head :ok }
      else
        @schools = School.paginate(
           :page=>params[:page],
           :order=>"title asc",
           :per_page=> $per_page
           )
        @new_school = School.new
        @edit_error = @edit_school.clone
        format.html { render :action => "index" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_page(object)
    page = School.all(:order => "school_name").index(object) / $per_page
    page += 1
    page
  end

end
