module AresMUSH
  class WebApp
    helpers do
      def unread_mail?
        unread_mail > 0
      end
      
      def unread_mail
        @user && @user.unread_mail.count
      end
    end
      
    get '/mail', :auth => :approved do
      @tag = params[:tag] || Mail.inbox_tag
        
      @tags = Mail.all_tags(@user).select { |t| t != Mail.inbox_tag }.sort
      @mail = @user.mail.select { |d| d.tags && d.tags.include?(@tag) }
      @mail.sort_by { |m| m.created_at }
              
      erb :"mail/index"
    end
    
    get '/mail/:id', :auth => :approved do |id|
      @mail = MailMessage[id]
      @mail.mark_read
      erb :"mail/message"
    end
    
    post '/mail', :auth => :approved do
      to = params[:to_list]
      subject = params[:subject]
      message = format_input_for_mush params[:message]
      
      
      redirect "/mail/#{mail.id}"
    end
      
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
