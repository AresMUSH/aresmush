module AresMUSH
  module Mail
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
      
        char.mail_filter = Mail.inbox_tag
        char.save
      
        Mail.empty_trash(char)
      end
    end
  end
end