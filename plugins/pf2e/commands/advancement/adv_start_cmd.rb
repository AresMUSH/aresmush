module AresMUSH
  module Pf2e
    class AdvStartCmd
      include CommandHandler

      def handle
        result = Pf2e.adv_start(enactor)
        unless result[:ok]
          if result[:error] == "pf2e.adv_insufficient_xp"
            client.emit_failure t('pf2e.adv_insufficient_xp',
                                  :xp => result[:xp],
                                  :need => result[:xp_to_level])
          else
            client.emit_failure t(result[:error])
          end
          return
        end

        p = result[:pending]
        client.emit_success t('pf2e.adv_start_ok',
                              :level => result[:level],
                              :skill => p["skill_increase"],
                              :boost => p["ability_boost"])
        client.emit t('pf2e.adv_start_next')
      end
    end
  end
end
