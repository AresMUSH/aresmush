module AresMUSH
  class WebApp    
    get '/jobs', :auth => :admin do
      @jobs = Jobs.filtered_jobs(@user, "ACTIVE")
      erb :"jobs/index"
    end
    
  end
end
