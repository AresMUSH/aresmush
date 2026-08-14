module AresMUSH
  module Pf2e
    class CgSkillCmd
      include CommandHandler

      attr_accessor :skills

      def parse_args
        self.skills = cmd.args.to_s.split.map { |s| s.strip.downcase }.reject(&:empty?)
      end

      def handle
        # No args → status (picks remaining + trained list)
        if self.skills.empty?
          result = Pf2e.cg_skill_status(enactor)
          if !result[:ok]
            client.emit_failure t(result[:error])
            return
          end

          forced = result[:forced].empty? ? "(none)" : result[:forced].join(", ")
          trained = result[:trained].empty? ? "(none)" : result[:trained].join(", ")
          client.emit t('pf2e.cg_skill_status',
                       :total => result[:total],
                       :used => result[:used],
                       :remaining => result[:remaining],
                       :forced => forced,
                       :trained => trained)
          return
        end

        result = Pf2e.cg_train_skills(enactor, self.skills)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.cg_skill_set',
                             :list => result[:trained].join(", "),
                             :remaining => result[:remaining])
      end
    end
  end
end
