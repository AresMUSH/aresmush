module AresMUSH
  class WebApp    
    get '/jobs', :auth => :admin do
      @jobs = Jobs.filtered_jobs(@user, "ACTIVE")
      erb :"jobs/jobs_index"
    end
    
  end
end
