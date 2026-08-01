module AresMUSH
  module Pf2e
    class CgBgskillCmd
      include CommandHandler

      attr_accessor :choice

      def parse_args
        self.choice = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        if self.choice.blank?
          result = Pf2e.cg_background_skill_status(enactor)
          if !result[:ok]
            client.emit_failure t(result[:error])
            return
          end

          if result[:total] == 0
            client.emit t('pf2e.cg_bgskill_none')
            return
          end

          pending = result[:pending].empty? ? "(none)" : result[:pending].join("; ")
          resolved = result[:resolved].empty? ? "(none)" : result[:resolved].join(", ")
          client.emit t('pf2e.cg_bgskill_status',
                       :resolved => resolved,
                       :pending => pending,
                       :remaining => result[:remaining])
          return
        end

        result = Pf2e.cg_resolve_background_skill(enactor, self.choice)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        if result[:feat]
          client.emit_success t('pf2e.cg_bgskill_set_with_feat',
                               :skill => result[:skill],
                               :feat => result[:feat],
                               :remaining => result[:remaining])
        else
          client.emit_success t('pf2e.cg_bgskill_set',
                               :skill => result[:skill],
                               :remaining => result[:remaining])
        end
      end
    end
  end
end
