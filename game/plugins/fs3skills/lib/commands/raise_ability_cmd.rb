module AresMUSH

  module FS3Skills
    class RaiseAbilityCmd
      include CommandHandler
      
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'abilities'
        }
      end
      
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def handle
        current_rating = FS3Skills.ability_rating(enactor, self.name)
        mod = cmd.root_is?("raise") ? 1 : -1
        FS3Skills.set_ability(client, enactor, self.name, current_rating + mod)
      end
    end
  end
end
