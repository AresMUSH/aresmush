module AresMUSH
  module Who
    class CharConnectedEventHandler
      def on_event(event)
        count = Global.client_monitor.logged_in_clients.count
        game = Game.master
        char = Character[event.char_id]
        
        if (count > game.online_record)
          game.update(online_record: count)
          Global.logger.info("Online Record Now: #{count}")
          
          Achievements.award_achievement(char, "who_record_broken", :community, "Broke the online record.")
          
          Global.notifier.notify_ooc(:who_record, t('who.new_online_record', :count => count)) do |char|
            true
          end
        end
      end      
    end
  end
end
