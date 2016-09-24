module AresMUSH
  module OOCTime
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        client.char.timezone = Global.read_config("ooctime", "default_timezone")
        client.emit_ooc t('time.default_timezone_set', :timezone => client.char.timezone)
      end
    end
  end
end
