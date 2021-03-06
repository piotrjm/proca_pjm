class Projects::PointFilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_point_file, only: [:show, :edit, :update, :destroy]


  # ZsPoints for showed PointFile
  def datatables_index_zs_point
    respond_to do |format|
      format.json{ render json: PointFileZsPointsDatatable.new(view_context, { only_for_current_point_file_id: params[:point_file_id] }) }
    end
  end


  def download
    @point_file = PointFile.find(params[:id])
#    attachment_authorize(:attachment, "show", @attachment.attachmenable_type.singularize.downcase)    
    send_file "#{@point_file.load_file.file.file}", 
      type: "#{@point_file.load_file.file.content_type}",
      x_sendfile: true
  end

  # GET /point_files/1
  # GET /point_files/1.json
  def show
    @project = load_project
  end

  # GET /point_files/new
  def new
    @project = load_project
    @point_file = PointFile.new
    @point_file.project = @project
    @point_file.load_date = Time.zone.today 
#    authorize :point_file, :new?
  end

  # GET /point_files/1/edit
  def edit
    @project = load_project
  end

  # POST /point_files
  # POST /point_files.json
  def create
    @project = load_project
    @point_file = PointFile.new(point_file_params)
    @point_file.project = @project
#    authorize @point_file, :create?
    respond_to do |format|
      if @point_file.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @point_file.fullname)
        @point_file.load_data_from_csv_file
        flash[:notice] = "Pomyślnie załadowano #{@point_file.zs_points.size} punktów ZS"
        format.html { redirect_to project_point_file_path(@project, @point_file) }
        format.json { render :show, status: :created, location: @point_file }
      else
        format.html { render :new }
        format.json { render json: @point_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /point_files/1
  # PATCH/PUT /point_files/1.json
  def update
    @project = load_project
#    authorize @point_file, :update?
    respond_to do |format|
      if @point_file.update(point_file_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @point_file.fullname)
        format.html { redirect_to project_point_file_path(@project, @point_file) }
        format.json { render :show, status: :ok, location: @point_file }
      else
        format.html { render :edit }
        format.json { render json: @point_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /point_files/1
  # DELETE /point_files/1.json
  def destroy
    @project = load_project
#    authorize @point_file, :destroy?
    if @point_file.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @point_file.fullname)
      redirect_to project_path(@project)
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @point_file.fullname)
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_point_file
      @point_file = PointFile.find(params[:id])
    end

    def load_project
      @project = Project.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def point_file_params
      params.require(:point_file).permit(:project_id, :load_date, :load_file, :load_file_cache, :status, :note)
    end
end
