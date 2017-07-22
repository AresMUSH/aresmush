module AresMUSH
  class WebApp
    
    get '/job/:id', :auth => :admin do |id|
      @job = Job[id]      
      Jobs.mark_read(@job, @user)
      erb :"jobs/job"
    end
    
  end
end
