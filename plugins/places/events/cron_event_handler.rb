module AresMUSH
  module Places
    class CronEventHandler
      def on_event(event)

        config = Global.read_config("places", "places_cleanup_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Cleaning up places."

        Character.all.each do |c|
          Custom.update_potion_hours(c)
        end

        Place.all.each do |p|
          if (p.characters.empty?)
            p.delete
          end
        end
      end
    end
  end
end
