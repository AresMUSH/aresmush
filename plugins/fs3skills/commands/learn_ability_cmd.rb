module AresMUSH

  module FS3Skills
    class LearnAbilityCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end

      def check_if_spell
        return t('magic.do_spell_learn') if Magic.is_spell?(self.name)
      end

      def check_chargen_locked
        return t('fs3skills.must_be_approved') if !enactor.is_approved?
        return nil
      end

      def check_xp
        return t('fs3skills.not_enough_xp') if enactor.xp <= 0
      end

      def handle
        error = FS3Skills.learn_ability(enactor, self.name)
        if (error)
          client.emit_failure error
        else
          client.emit_success t('fs3skills.xp_spent', :name => self.name)
        end
      end
    end
  end
end
