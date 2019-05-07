module AresMUSH
  module FS3Magix
    class MagixCronHandler
      def on_event_will(event)
        config = Global.read_config("fs3magix", "will_cron")
        return if !Cron.is_cron_match?(config, event.time)
        Global.logger.debug "Time for restoration of will."
        Custom.channel_alert("Running Will Restoration.")
      end
      def on_event_sanity(event)
        config = Global.read_config("fs3magix", "sanity_cron")
        return if !Cron.is_cron_match?(config, event.time)
        Global.logger.debug "Time for a sanity check."
        Custom.channel_alert("Running Sanity Check.")
      end
    end
  end
end
