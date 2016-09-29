module AresMUSH

  module FS3Skills
    class RaiseAbilityCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include CommandWithoutSwitches
      
      attr_accessor :name

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'abilities'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_ability_type
        ability_type = FS3Skills.get_ability_type(enactor, self.name)
        valid_types = [:action, :advantage]
        return t('fs3skills.wrong_type_for_ability_command') if !valid_types.include?(ability_type)
        return nil
      end
      
      def check_advantages_enabled
        ability_type = FS3Skills.get_ability_type(enactor, self.name)
        return t('fs3skills.advantages_not_enabled') if (ability_type == :advantage && !FS3Skills.advantages_enabled?)
        return nil
      end
      
      
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def handle
        current_rating = FS3Skills.ability_rating(enactor, self.name)
        mod = cmd.root_is?("raise") ? 1 : -1
        FS3Skills.set_ability(client, enactor, self.name, current_rating + mod)
        enactor.save
      end
    end
  end
end
