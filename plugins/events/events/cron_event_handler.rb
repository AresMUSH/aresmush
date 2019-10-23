module AresMUSH
  module Events
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("events", "event_alert_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Upcoming event notifications."

        Event.all.each do |e|
          time_until_event = e.time_until_event
          if (!e.reminded &&  time_until_event < (60 * 20) && time_until_event > 0)

            message = t('events.event_starting_soon', :title => e.title,
               :starts => e.start_time_standard)
            Channels.announce_notification(message)
            
            Global.notifier.notify_ooc(:event_starting, message) do |char|
              char && e.participants.include?(char)
            end
            
            e.update(reminded: true)
          end

          if (e.time_until_event < (0 - (30*60)))
            e.delete
          end
        end
        # Global.logger.debug "Ending event cron."
      end
    end
  end
end
