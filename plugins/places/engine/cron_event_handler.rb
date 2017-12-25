module AresMUSH
  module Places
    class CronEventHandler
      def on_event(event)
        
        Global.client_monitor.logged_in do |client, char|
          if (char.place && char.place.room != char.room)
            char.upate(place: nil)
          end
        end
        
        config = Global.read_config("places", "places_cleanup_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Place.all.each do |p|
          if (p.characters.empty?)
            p.delete
          end
        end
      end
    end
  end
end