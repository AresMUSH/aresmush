module AresMUSH
  module Magic
    class ShieldCronHandler

      def on_event(event)
        config = Global.read_config("magic", "shield_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Non-combat magic shields expiring."

        Character.all.each do |c|
          Magic.shields_expire(c)
        end

      end

    end
  end
end
