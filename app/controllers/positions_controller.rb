class PositionsController < ApplicationController
  # GET /positions
  # GET /positions.xml
  def index
    @positions = Position.all
    @new_position = Position.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.xml
  def show
    @position = Position.find(params[:id])
    @exam_list = Exam.where("id NOT IN (" +
        "SELECT exam_id " +
        "FROM exam_position_assignments " +
        "WHERE position_id = ?)", @position)

    respond_to do |format|
      format.html
      format.xml { render :xml => @position}
    end
  end

  # GET /positions/new
  # GET /positions/new.xml
  def new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.xml
  def create
    @position = Position.new(params[:position])

    respond_to do |format|
      if @position.save
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Created new position -> "+@position.id.to_s)
        format.html { redirect_to(positions_path, :notice => 'Position was successfully created.') }
        format.xml  { render :xml => positions_path, :status => :created, :location => @position }
      else
        @positions = Position.all
        @new_position = @position.clone
        format.html { render :action => "index" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
    @edit_position = Position.find(params[:id])
    unless @current
      @current = @edit_position.clone
    end

    respond_to do |format|
        puts "respond" + @edit_position.title

      if @edit_position.update_attributes(params[:position])
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Updated a position -> "+@edit_position.id.to_s)
        @edit_error = nil
        session['updated'] = @edit_position
        format.html { redirect_to(positions_path, :notice => 'Position was successfully updated.')}
        format.xml  { head :ok }
      else
        @positions = Position.all
        @new_position = Position.new

        @edit_error = @edit_position.clone
        format.html { render :action => "index"}
        # format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])
    AdminLog.create(:admin_id=>session[:admin_id], :log=>"Removed a position -> "+@position.id.to_s)
    @position.destroy

    respond_to do |format|
      format.html { redirect_to(positions_url) }
      format.xml  { head :ok }
    end
  end

  def assign
    @exam = Exam.find(params[:exam_id])
    @position = Position.find(params[:id])

    @epa = ExamPositionAssignment.new
    @epa.exam = @exam
    @epa.position = @position

    respond_to do |format|
      @position = Position.find(params[:id])
      @exam_list = Exam.where("id NOT IN (" +
        "SELECT exam_id " +
        "FROM exam_position_assignments " +
        "WHERE position_id = ?)", @position)

      if@epa.save
        AdminLog.create(:admin_id=>session[:admin_id], :log=>"Assigned exam -> "+@exam.id.to_s+" to position -> "+@position.id.to_s)
        format.html { redirect_to @position, :notice=>"#{@exam.title} successfully added."}
      else
        format.html { render :action => "show"}
      end
    end
  end

  def unassign
    @exam = Exam.find(params[:exam_id])
    @position = Position.find(params[:id])

    @epa = ExamPositionAssignment.where(:position_id => @position, :exam_id => @exam)
    AdminLog.create(:admin_id=>session[:admin_id], :log=>"Removed exam -> "+@exam.id.to_s+" to position -> "+@position.id.to_s)
        
    respond_to do |format|
       if @epa.last.destroy
         format.html { redirect_to @position}
       else
         format.html { render :action => "show"}
       end
     end
  end
end
