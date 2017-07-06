module AresMUSH
  class WebApp
    
    post '/mail/send', :auth => :approved do
      message = format_input_for_mush params[:message]
      to = params[:to]
      subject = params[:subject]
        
      if (subject.blank? || message.blank? || to.blank?)
        flash[:error] = "Subject, to list and message required."
        redirect "/mail"
      end
        
      sent = Mail.send_mail(to.split(" "), subject, message, nil, @user)
        
      if (sent)
        flash[:info] = "Message sent."
      else
        flash[:error] = "Error sending message.  Please try again later."
      end
      redirect "/mail"
    end
    
  end
end
