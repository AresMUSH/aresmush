module AresMUSH
  module OOCTime
    class LoginEvents
      include Plugin
      
      def on_char_created_event(event)
        client = event.client
        # TODO - someday find timezone by IP address.  For now use default
        client.char.timezone = Global.config['time']['default_timezone']
        client.emit_ooc t('time.default_timezone_set', :timezone => client.char.timezone)
      end
    end
  end
end
