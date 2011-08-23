class ProjectFormController < ApplicationController
  
  def show

  end
  
  def file_upload
    
     # uploaded_io = params [:picture]
      #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
       # file.write(uploaded_io.read)
     #end
  end
  
  def form_validation
    
    @errors = Array.new
      # validation
      if params[:title].blank?
       @errors.push("You need to enter a project title")
      end
      
      
      
      if @errors.count==0
           #no errors, save the data and redirect to dashboard
      redirect_to '/dashboard'
      else
      #there has been errors print them on the template
        render :template => 'project_form/show'
      end
    
  end
end
