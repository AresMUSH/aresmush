module AresMUSH
  module Login
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        Global.logger.info("Character Created: #{char.name}")
        
        Global.notifier.notify_ooc(:char_created, t('login.announce_char_created', :name => char.name)) do |char|
          true
        end
      end
    end
  end
end
