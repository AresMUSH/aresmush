module AresMUSH
  module OOCTime
    class LoginEvents
      include CommandHandler
      
      def on_char_created_event(event)
        client = event.client
        client.char.timezone = Global.read_config("time", "default_timezone")
        client.emit_ooc t('time.default_timezone_set', :timezone => client.char.timezone)
      end
    end
  end
end
