module AresMUSH

  module FS3Skills
    class LearnAbilityCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include CommandWithoutSwitches
      
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'xp'
        }
      end
      
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def check_xp
        return t('fs3skills.not_enough_xp') if enactor.xp <= 0
      end
      
      def handle
        FS3Skills.learn_ability(client, enactor, self.name)
      end
    end
  end
end
