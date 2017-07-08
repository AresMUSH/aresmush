module AresMUSH
  class WebApp
    
    get '/mail/:id', :auth => :approved do |id|
      @mail = MailMessage[id]
      @mail.mark_read
      erb :"mail/message"
    end    
    
  end
end
