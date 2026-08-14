module AresMUSH
  module Pf2e
    class AdvFinishCmd
      include CommandHandler

      def handle
        result = Pf2e.adv_finish(enactor)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.adv_finish_ok',
                              :level => result[:level],
                              :subtracted => result[:subtracted],
                              :xp => result[:xp],
                              :need => result[:xp_to_level])
      end
    end
  end
end
