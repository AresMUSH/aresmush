module AresMUSH
  class Character  
    def has_unread_mail?
      !unread_mail.empty?
    end
  end
  
  module Mail
    module Api
      def self.send_mail(names, subject, body, client, author = nil)
        Mail.send_mail(names, subject, body, client, author)
      end
    end
  end
end