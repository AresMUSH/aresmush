module AresMUSH
  class WebApp
    
    get '/job/:id/close', :auth => :admin do |id|
      @job = Job[id]      
      Jobs.close_job(@user, @job, message = nil)
         
      flash[:info] = "Job closed."
      redirect "/job/#{@job.id}"
    end
  end
end
