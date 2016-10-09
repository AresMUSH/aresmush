module AresMUSH
  module Mail
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
      
        prefs = Mail.get_or_create_mail_prefs(char)
        prefs.update(mail_filter:  Mail.inbox_tag)
      
        Mail.empty_trash(char)
      end
    end
  end
end