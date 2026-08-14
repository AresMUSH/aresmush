module AresMUSH
  module Pf2e
    class AdvStatusCmd
      include CommandHandler

      def handle
        result = Pf2e.adv_status(enactor)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        p = result[:pending]
        lines = []
        lines << t('pf2e.adv_status_header',
                   :level => result[:level],
                   :xp => result[:xp],
                   :need => result[:xp_to_level])
        lines << t('pf2e.adv_status_progress',
                   :xp => result[:xp],
                   :need => result[:xp_to_level],
                   :left => result[:xp_needed])

        if result[:advancing]
          lines << t('pf2e.adv_status_advancing')
          lines << t('pf2e.adv_status_pending',
                     :skill => p["skill_increase"],
                     :boost => p["ability_boost"],
                     :class_feat => p["class_feat"],
                     :skill_feat => p["skill_feat"],
                     :general_feat => p["general_feat"],
                     :ancestry_feat => p["ancestry_feat"])
          lines << t('pf2e.adv_status_finish_hint')
        elsif result[:can_start]
          lines << t('pf2e.adv_status_ready')
        else
          lines << t('pf2e.adv_status_not_ready', :left => result[:xp_needed])
        end

        client.emit lines.join("\n")
      end
    end
  end
end
