module AresMUSH
  module FS3Magix
    class SanityCronHandler
      def on_event(event)
        config = Global.read_config("fs3magix", "sanity_cron")
        return if !Cron.is_cron_match?(config, event.time)
        Global.logger.debug "Time for a sanity check."
        Custom.channel_alert("Running Sanity Check.")
      end
    end
  end
end
