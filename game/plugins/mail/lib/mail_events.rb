module AresMUSH
  module Mail
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
      
        char.update(mail_filter:  Mail.inbox_tag)
      
        Mail.empty_trash(char)
      end
    end
  end
end