module DashboardHelper
  
  
  
    def project_status(start_date, end_date)
      
      if ((start_date <=> Date.current) ==1)
        return [1, "Pipeline"]
      elsif (end_date== nil) || ((end_date<=> Date.current) ==1)
        return [2, "Implementing"]
      else
        return [3, "Completion"]
      end
    end


end
