class ProjectController < ApplicationController
  
  def new


    if params[:method]=="post"
      @errors = Array.new
        # Title validation
        if params[:title].blank?
         @errors.push("You need to enter a project title")
        end
        if params[:sector_type].match("1")
         @errors.push("You need to select a sector")
        end
        if !params[:budget].blank? && params[:currency].match("1")
         @errors.push("You need to select a currency")
        end
      
        if @errors.count==0
             #no errors, save the data and redirect to dashboard
        redirect_to '/dashboard'
        else
        #there has been errors print them on the template
        end   
    end


  end
  
  
end
