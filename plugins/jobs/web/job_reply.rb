module AresMUSH
  class WebApp
    
    post '/job/:id/reply', :auth => :admin do |id|
      message = format_input_for_mush params[:message]
      admin_only = params[:adminonly].to_bool
      
      job = Job[id]
      
      if (message.blank?)
        flash[:error] = "Message required."
        redirect "/job/#{id}"
      end
      
      Jobs.comment(job, @user, message, admin_only)      
      redirect "/job/#{id}"
    end
    
  end
end
