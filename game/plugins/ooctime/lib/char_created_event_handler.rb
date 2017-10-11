module AresMUSH
  module OOCTime
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        timezone = Global.read_config("ooctime", "default_timezone")
        char.update(ooctime_timezone: timezone)
        if (client)
          client.emit_ooc t('time.default_timezone_set', :timezone => timezone)
        end
      end
    end
  end
end
