module AresMUSH
  module OOCTime
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        timezone = Global.read_config("ooctime", "default_timezone")
        event.char.update(ooctime_timezone: timezone)
        client.emit_ooc t('time.default_timezone_set', :timezone => timezone)
      end
    end
  end
end
