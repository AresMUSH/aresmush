module AresMUSH
  module Mail
    module Interface
      def self.send_mail(names, subject, body, client)
        Mail.send_mail(names, subject, body, client)
      end
    
      def self.has_unread_mail?(char)
        char.has_unread_mail?
      end
    end
  end
end