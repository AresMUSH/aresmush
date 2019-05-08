module AresMUSH
  module FS3Magix
    class MagixCronHandler
      def on_event(event)
        if (Cron.is_cron_match?(Global.read_config("fs3magix", "sanity_cron"), event.time))
          handle_sanity_check
        end

        if (Cron.is_cron_match?(Global.read_config("fs3magix", "will_cron"), event.time))
          handle_will_restoration
        end

        if (Cron.is_cron_match?(Global.read_config("fs3magix", "will_cron"), event.time))
          handle_will_restoration
        end


      end
      def handle_will_restoration
        Global.logger.debug "Time for restoration of will."
        Custom.channel_alert("Running Will Restoration.")
      end
      def handle_sanity_check
        Global.logger.debug "Time for a sanity check."
        Custom.channel_alert("Running Sanity Check.")
      end
    end
  end
end
