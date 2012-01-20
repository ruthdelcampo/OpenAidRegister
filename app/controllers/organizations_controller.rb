class OrganizationsController < ApplicationController

  # we can use this route to render a public list of organizations
  # GET /organizations
  #----------------------------------------------------------------------

  def index
    redirect_to root_path # for now
  end

  # the public organization page, this one can render html or xml in the
  # future
  # GET /organizations/:id.:format
  #----------------------------------------------------------------------

  def show
    redirect_to projects_organization_path(params[:id], :format => :xml)
  end

  # GET /organizations/:id/projects.:format
  #----------------------------------------------------------------------

  def projects
    # take the organization information. This request can also be done from outside people
    @download_organization = Organization.find(params[:id])
    # we need to check if there is an existing organization, else it will be error 404
    if @download_organization.present?
      # get the project info
      @download_projects = Project.by_organization_id(params[:id])
      # Render XML if it has already projects entered and the organization is validated
      if @download_projects.present?
        # get the se project_sector info
        @download_sectors = ProjectSector.by_organization_id_grouped_by_project(params[:id])
        # get the sector names
        @download_sector_names = ProjectSector.names
        # now partner organizations. I need to check if this finally works well
        @download_other_orgs = ProjectPartnerorganization.by_organization_id_grouped_by_project(params[:id])
        # now transactions
        @transaction_list = ProjectTransaction.by_organization_id(params[:id])
        # now related docs
        @download_related_docs = ProjectRelateddoc.by_organization_id(params[:id])
        #get the geo information
        @download_geo_projects = ReverseGeo.by_organization_id(params[:id])
        #finally render the XML
        render :template => '/organizations/projects.xml.erb', :layout => false
      else #if there are still no projects
        render :template => '/organizations/empty.html.erb', :layout => false
      end
    else
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found
    end
  end

end
