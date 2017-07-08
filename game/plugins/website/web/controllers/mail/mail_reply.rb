module AresMUSH
  class WebApp

    post '/mail/reply', :auth => :approved do
      id = params[:mail_id]
      message = format_input_for_mush params[:message]
        
      mail = MailMessage[id]
      to = mail.author_name
      subject = "Re: #{mail.subject}"
        
      if (message.blank?)
        flash[:error] = "Message required."
        redirect "/mail/#{id}"
      end
        
      sent = Mail.send_mail([to], subject, message, nil, @user)
        
      if (sent)
        flash[:info] = "Message sent."
      else
        flash[:error] = "Error sending message.  Please try again later."
      end
      redirect "/mail"
    end
    
  end
end
