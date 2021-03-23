module AresMUSH
  module Magic
    class ShieldCronHandler

      def on_event(event)
        config = Global.read_config("magic", "shield_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Magic shields expiring."

        Character.all.each do |c|
          shields = c.magic_shields
          shields.each do |shield|            
            shield.delete
          end
        end

      end

    end
  end
end
