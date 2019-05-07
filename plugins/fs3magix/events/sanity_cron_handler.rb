module AresMUSH
  module FS3Magix
    class SanityCronHandler
      def on_event(event)
        config = Global.read_config("fs3magix", "sanity_cron")
        return if !Cron.is_cron_match?(config, event.time)
      end
    end
  end
end
