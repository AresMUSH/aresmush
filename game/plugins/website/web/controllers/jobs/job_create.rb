module AresMUSH
  class WebApp
    
    post '/jobs/post', :auth => :admin do
      id = params[:job_id]
      title = params[:title]
      category = params[:category]
      message = format_input_for_mush params[:message]
      
      
      if (title.blank? || message.blank?)
        flash[:error] = "Title and message required."
        redirect "/jobs"
      end
      
      job = Jobs.create_job(category, 
         title, 
         message, 
         @user)
         
      redirect "/job/#{job.id}"
    end
  end
end
