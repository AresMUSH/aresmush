module AresMUSH
  module OOCTime
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        timezone = Global.read_config("ooctime", "default_timezone")
        prefs = TimePrefs.create(character: event.char, timezone: timezone)
        event.char.update(time_prefs: prefs)
        client.emit_ooc t('time.default_timezone_set', :timezone => timezone)
      end
    end
  end
end
