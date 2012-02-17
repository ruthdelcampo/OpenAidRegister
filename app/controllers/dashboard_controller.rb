class DashboardController < ApplicationController

  before_filter :require_login

  # SHOW
  #----------------------------------------------------------------------

  def show
    # We need to initialize the errors array to be shown when there is aproblem with import file
    @errors = Array.new

    result = Organization.dashboard_projects(session[:organization][:cartodb_id])
    # order projects by start date to be shown in the dashboard.
    # Last projects will be the ones with nil.
    @ordered_projects_list = result.rows.sort{|a,b| ( a.start_date and b.start_date ) ? b.start_date <=> a.start_date : ( a.start_date ? -1 : 1 ) }

    @current_projects = 0
    @past_projects = 0

    # check which ones are current and which are past
    @ordered_projects_list.each do |project|
      if (project[:end_date]== nil) || ((project[:end_date]<=> Date.current) ==1)
        @current_projects +=1
      else
        @past_projects +=1
      end
    end
  end

  # IMPORT_FILE
  # TODO: not completely working. Need to add functionallity
  #----------------------------------------------------------------------

  def import_file

    redirect_to '/dashboard', :alert => "You need to choose a file first" and return if params[:file_upload].blank?

    file_name = params[:file_upload].original_filename
    file      = params[:file_upload].tempfile

    result = AWS::S3::S3Object.store("#{session[:organization][:cartodb_id]}_#{file_name}", file, 'openaidregister_uploads')


    # send an email notification to ruth del Campo
    UserMailer.new_file(session[:organization], file_name).deliver

    redirect_to '/dashboard', :notice => <<-EOF
      Thanks for uploading the file.
      We are going to import your projects.
      In a few days you will see you projects uploaded.
      We will contact you if we need some help and you will get an email when the process is completed.
    EOF
    return
  end

  # DELETE
  # deletes a project and all the related data
  #----------------------------------------------------------------------

  def delete
    # check if the project belongs to the organization before deleting it
    project = Project.find(params[:delete_project_id], session[:organization][:cartodb_id])
    if project # yay! the project belongs to the org, so we can delete it
      Project.destroy(params[:delete_project_id])
    else
      flash[:notice] = "You can't delete the selected project"
    end
    redirect_to  '/dashboard'
  end

  # PUBLISH
  # TODO: not working
  #----------------------------------------------------------------------

  def publish
    redirect_to "/dashboard", :notice => "Sorry, this functionality is not yet implemented but you can always contact us for help"

    #if session[:organization][:is_valid_publish]
    #   #send to IATI REgistry
    #     if # no_success
    #        #email to contact@openaidregister to check what happened
    #        render :text => 'There was an error while inserting the data in IATI Registry. Please try again later or contact us'
    #      else #if success
    #        #sql insert new data since it was succesful
    #          api_key = params[:api_key]
    #          name_package = params[:name_package]
    #        render :text => "Succesfully updated"
    #       end
    #elsif session[:organization][:api_key].present? && session[:organization][:package_name].present?
    #    if #no success
    #      #email to contact@openaidregister to check what happened
    #      render :text => 'There was an error while inserting the data in IATI Registry. Please check your IATI Details are correct'
    #    else #if success
    #      session[:organization][:is_valid_publish]
    #    end
    #else
    #    redirect_to '/dashboard', :alert => "Please, introduce your IATI Registry (api key and the name package) details in your account. We need this information to be able to publish your data in the Registry.  For more information or if you dont know how to do this step, please send us an email to contact@openaidregister.org"
    #end
  end

end
