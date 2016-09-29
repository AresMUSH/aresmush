module AresMUSH
  module Mail
    module Api
      def self.send_mail(names, subject, body, client, author = nil)
        Mail.send_mail(names, subject, body, client, author)
      end
    
      def self.has_unread_mail?(char)
        char.has_unread_mail?
      end
    end
  end
end