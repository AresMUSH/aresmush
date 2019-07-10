module AresMUSH
  module Login
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        Global.logger.info("Character Created: #{char.name}")
        
        Channels.announce_notification t('login.announce_char_created', :name => char.name)
      end
    end
  end
end
