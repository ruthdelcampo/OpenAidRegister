class ProjectsController < ApplicationController

  before_filter :require_login, :except => :show

  # GET /projects
  #----------------------------------------------------------------------
  def index
    # redirect to the dashboard for now
    redirect_to dashboard_path
  end

  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  #----------------------------------------------------------------------
  def new
    @errors = []
    @latlng = []
    @project_data = {}
  end

  # POST /projects
  #----------------------------------------------------------------------
  def create
    @errors = []
    @latlng = []
    @project_data = params
    @start_date = "null"
    @end_date   = "null"
    validate_params
    # there has been errors print them on the template AND EXIT
    if @errors.count > 0
      render :new
    else
      # create the project
      project = Project.create(params, session[:organization].cartodb_id, @start_date, @end_date)
      # Now sectors must be written
      ProjectSector.create_many(project[:cartodb_id], params[:sectors])
      # participating orgs
      ProjectPartnerorganization.create_many(project[:cartodb_id], params[:participating_orgs])
      # transactions
      ProjectTransaction.create_many(project[:cartodb_id], params[:transaction_list])
      # related docs
      ProjectRelateddoc.create_many(project[:cartodb_id], params[:related_docs])
      # reverse geo
      ReverseGeo.create_many(project[:cartodb_id], params[:reverse_geo])
      redirect_to dashboard_path
    end
  end

  # GET /projects/:id/edit
  #----------------------------------------------------------------------
  def edit
    @errors = []
    @project_data = Project.find(params[:id])
    @project_data[:latlng] = []

    # select sectors and form the array
    project_sectors_ids = ProjectSector.ids_where_project_id(params[:id])
    if !project_sectors_ids.blank?
      @project_data[:sector_id] = project_sectors_ids
    end

    @project_data[:sectors] = ProjectSector.kv_ids_where_project_id(params[:id])
    # Select partner organizations and form the array
    @participating_orgs = ProjectPartnerorganization.by_project_id(params[:id])
    # geo data
    @project_data[:reverse_geo] = ReverseGeo.by_project_id(params[:id])
    # @reverse_geo will be used for painting the points in the map with jquery
    (@project_data[:reverse_geo] || []).each_with_index do |row, index|
      @project_data[:latlng][index]= row[:latlng]
    end
    # transactions
    # Select partner organizations and form the array
    @project_data[:transaction_list] = ProjectTransaction.by_project_id(params[:id])
    # related docs
    @project_data[:related_docs] = ProjectRelateddoc.by_project_id(params[:id])
  end

  # PUT /projects/:id
  #----------------------------------------------------------------------
  def update
    @errors = []
  #  @latlng = []
    @start_date = "null"
    @end_date   = "null"
    @project_data = params

    validate_params
    # there has been errors print them on the template AND EXIT
    if @errors.count > 0
      debugger
      render :edit
    else
      Project.update(params[:cartodb_id], params, @start_date, @end_date)
      # In this case, first delete all sectors and overwrite them
      ProjectSector.delete_by_project_id(params[:cartodb_id])
      ProjectSector.create_many(params[:cartodb_id], params[:sectors])
      # In this case, first delete all partner organizations and overwrite them.
      ProjectPartnerorganization.delete_by_project_id(params[:cartodb_id])
      ProjectPartnerorganization.create_many(params[:cartodb_id], params[:participating_orgs])
      # In this case, first delete all transactions and overwrite them.
      ProjectTransaction.delete_by_project_id(params[:cartodb_id])
      ProjectTransaction.create_many(params[:cartodb_id], params[:transaction_list])
      # In this case, first delete all related docs and overwrite them.
      ProjectRelateddoc.delete_by_project_id(params[:cartodb_id])
      ProjectRelateddoc.create_many(params[:cartodb_id], params[:related_docs])
      # In this case, first delete all geo and overwrite them.
      ReverseGeo.delete_by_project_id(params[:cartodb_id])
      ReverseGeo.create_many(params[:cartodb_id], params[:reverse_geo])

      redirect_to dashboard_path
    end
  end

private

  # VALIDATE PARAMS
  #----------------------------------------------------------------------

  def validate_params
    if params[:title].blank?
      @errors.push("You need to enter a project title")
    end

    if params[:budget].present?
      if !Oar::is_a_number?(params[:budget])
        @errors.push("Budget must be written in numbers")
      end
      if params[:budget_currency].eql?("1")
        @errors.push("You need to select a currency")
      end
    end

    if params[:project_guid].blank?
      @errors.push("You need to enter a project id")
    end

    if params[:org_role].blank?
      @errors.push("You need to select what is you organization's role in this project")
    end

    # check that the project id is unique for this user
    sql = "SELECT cartodb_id, project_guid FROM projects WHERE organization_id = '?'"
    result = Oar::execute_query(sql, session[:organization].cartodb_id)
    result.rows.each do |project|
      # check if there is no repeted cartodb_id but only when it is updating project
      if params[:project_guid] == project.project_guid && params[:cartodb_id] != project.cartodb_id.to_s
        @errors.push("Please change the project id. You have already one project with this id")
      end
    end

    # Check if the day is not correct
    # for instance when there is an end date but not a start date
    if !(params[:end_date] =="") && (params[:start_date]=="")
      @errors.push("You need to have a start date when you have introduced and end date")
    end
    # End date cant be earlier as the start date
    if params[:end_date].present? && params[:start_date].present?
      month, day, year = *params[:start_date].split('/').map(&:to_i)
      @start_date = Date.new(year, month, day)
      month, day, year = *params[:end_date].split('/').map(&:to_i)
      @end_date = Date.new(year, month, day)

      @errors.push("The end date must be later than the start date") if @start_date > @end_date
    end

    # it is a permanent project
    if params[:start_date].present? && (params[:end_date] =="")
      month, day, year = *params[:start_date].split('/').map(&:to_i)
      @start_date = Date.new(year, month, day)
    end

    if params[:contact_email].present? && !Oar::match_email(params[:contact_email])
      @errors.push("The format of the contact email is wrong")
    end

    # Prepare the date to be inserted in CartoDB
    @start_date = "null" if params[:start_date].blank?
    @end_date   = "null" if params[:end_date].blank?

    # prepare the project id. Take out all possible spaces and transform them to
    params[:project_guid] = params[:project_guid].tr(" ", "-")
  end

end
