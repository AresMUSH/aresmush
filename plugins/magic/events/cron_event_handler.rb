module AresMUSH
  module Magic
    class MagicCronEventHandler

      def on_event(event)
        shield_cron = Global.read_config("magic", "shield_cron")
        if Cron.is_cron_match?(shield_cron, event.time)
          Global.logger.debug "Non-combat magic shields expiring."

          Character.all.each do |c|
            Magic.shields_expire(c)
          end
        end

        potion_cron = Global.read_config("magic", "potion_cron")
        if Cron.is_cron_match?(potion_cron, event.time)
          Global.logger.debug "Potion creation time updating"

          Character.all.each do |c|
            Custom.update_potion_hours(c)
          end
        end

      end

    end
  end
end
