class DepartmentsController < ApplicationController
  # GET /departments
  # GET /departments.xml

  $per_page = 10 

  def index
    @departments = Department.paginate(
      :page=>params[:page],
      :order=>"department_name asc",
      :per_page=> $per_page
    )

    @new_department = Department.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departments }
    end
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save

        page = find_page(@department)

        format.html { redirect_to(departments_path(:page=> page), :notice => 'Department was successfully created.') }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
      else
        @departments = Department.paginate(
          :page=>params[:page],
          :order=>"department_name asc",
          :per_page=> $per_page
          )
        @new_department = @department.clone
        format.html { render :action => "index" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @edit_department = Department.find(params[:id])

    respond_to do |format|
      if @edit_department.update_attributes(params[:department])
        @edit_error = nil
        session['updated'] = @edit_department

        page = find_page(@edit_department)
        format.html { redirect_to(departments_path(:page=>page), :notice => 'Department was successfully updated.') }
        format.xml  { head :ok }
      else
        @departments = Department.paginate(
        :page=>params[:page],
        :order=>"department_name asc",
        :per_page=> $per_page
        )
        @new_department = Department.new

        @edit_error = @edit_department.clone
        format.html { render :action => "index" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to(departments_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_page(object)
    page = Department.all(:order => "department_name").index(object) / $per_page
    page += 1
    page
  end
end