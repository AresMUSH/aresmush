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
      
    get '/mail/compose', :auth => :approved do
      erb :"mail/new_mail"
    end
  
    get '/mail/:id/?', :auth => :approved do |id|
      @mail = MailMessage[id]
      @mail.mark_read
      erb :"mail/message"
    end    
    
    get '/mail/?', :auth => :approved do
      @tag = params[:tag] || Mail.inbox_tag
        
      @tags = Mail.all_tags(@user).select { |t| t != Mail.inbox_tag }.sort
      @mail = @user.mail.select { |d| d.tags && d.tags.include?(@tag) }
      @mail.sort_by { |m| m.created_at }
              
      erb :"mail/mail_index"
    end
  end
end
