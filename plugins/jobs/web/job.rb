module AresMUSH
  class WebApp
    
    get '/job/:id/?', :auth => :admin do |id|
      @job = Job[id]      
      
      if (!Jobs.can_access_category?(@user, @job.category))
        flash[:error] = "You don't have access to the category that job is in."
        redirect "/jobs"
      end
      
      Jobs.mark_read(@job, @user)
      erb :"jobs/job"
    end
    
  end
end
