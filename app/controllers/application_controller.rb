class ApplicationController < ActionController::Base
  # rescue_from CartoDB::Client::Error :with => :deny_access

  protect_from_forgery

private

  def require_login
    if session[:organization].blank?
      session[:return_to] = request.request_uri
      redirect_to '/login'
      return
    end
  end

end


  #def cartodb_connect(sql) #It tries 2 times to connect to cartoDB. If no success, goes back to the previous page and sends an alert.
   #  begin
    #  result = CartoDB::Connection.query(sql)
     # puts result.to_s()
    #   return result
     #rescue CartoDB::Client::Error => error
      #   #puts error.to_s()
       #  begin
        #   CartoDB::Connection.query(sql)
      #     return result
      #   rescue CartoDB::Client::Error => error
       #    return error
      #    # redirect_to :back, :alert =>"sorry, it seems that there is a problem with the connection. Try it again in few minutes or send an email to support and we'll help you. "
       #   #send_email
      #    return false
      #   end
     #end
  # end

