class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role, only: [:show, :edit, :update, :destroy]


  def datatables_index_user
    respond_to do |format|
      format.json{ render json: UserRolesDatatable.new(view_context, { only_for_current_user_id: params[:user_id] }) }
    end
  end

  # GET /roles
  # GET /roles.json
  def index
    authorize :role, :index_any?
    @roles = Role.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    authorize @role, :show_any?
  end

  # GET /roles/new
  def new
    @role = Role.new
    authorize @role, :new?
  end

  # GET /roles/1/edit
  def edit
    authorize @role, :edit?
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)
    authorize @role, :create?
    respond_to do |format|
      if @role.save
        flash[:success] = t('activerecord.successfull.messages.created', data: @role.fullname)
        format.html { redirect_to @role }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    aa
    authorize @role, :update?
    respond_to do |format|
      if @role.update(role_params)
        flash[:success] = t('activerecord.successfull.messages.updated', data: @role.fullname)
        format.html { redirect_to @role }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    # @role.destroy
    # respond_to do |format|
    #   flash[:success] = "Role destroyed!"
    #   format.html { redirect_to roles_url }
    #   format.json { head :no_content }
    # end
    authorize @role, :destroy?
    if @role.destroy
      flash[:success] = t('activerecord.successfull.messages.destroyed', data: @role.fullname)
      redirect_to roles_url
    else 
      flash.now[:error] = t('activerecord.errors.messages.destroyed', data: @role.fullname)
      #redirect_to :back
      render :show
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :note, :activities, :special)
    end
end
