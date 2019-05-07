module AresMUSH
  module FS3Magix
    class WillCronHandler
      def on_event(event)
        config = Global.read_config("fs3magix", "will_cron")
        return if !Cron.is_cron_match?(config, event.time)
        Global.logger.debug "Time for restoration of will."
        Custom.channel_alert("Running Will Restoration.")
      end
    end
  end
end
