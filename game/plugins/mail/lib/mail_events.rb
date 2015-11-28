module AresMUSH
  module Mail
    class MailEvents
      include CommandHandler

      def on_char_disconnected_event(event)
        client = event.client
        char = client.char
      
        char.mail_filter = Mail.inbox_tag
        char.save
      
        Mail.empty_trash(client)
      end
    end
  end
end