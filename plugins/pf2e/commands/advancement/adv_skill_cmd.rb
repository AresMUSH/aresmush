module AresMUSH
  module Pf2e
    class AdvSkillCmd
      include CommandHandler

      attr_accessor :skill

      def parse_args
        self.skill = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        if self.skill.blank?
          client.emit_failure t('pf2e.adv_skill_usage')
          return
        end

        result = Pf2e.adv_skill_increase(enactor, self.skill)
        unless result[:ok]
          if result[:error] == "pf2e.adv_skill_rank_level"
            client.emit_failure t('pf2e.adv_skill_rank_level',
                                  :rank => result[:rank],
                                  :level => result[:level])
          else
            client.emit_failure t(result[:error])
          end
          return
        end

        client.emit_success t('pf2e.adv_skill_ok',
                              :skill => result[:skill],
                              :from => result[:from],
                              :to => result[:to],
                              :left => result[:pending]["skill_increase"])
      end
    end
  end
end
