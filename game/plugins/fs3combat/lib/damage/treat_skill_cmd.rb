module AresMUSH
  module FS3Combat
    class TreatSkillCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'damage'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("treat") && cmd.switch_is?("skill")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        char = client.char
        ability_rating = FS3Skills.ability_rating(char, self.name)

        if (ability_rating == 0)
          client.emit_failure t('fs3combat.invalid_treat_skill')
          return
        end
        
        char.treat_skill = self.name
        char.save
            
        client.emit_success t('fs3combat.treat_skill_set', :name => self.name)
      end
    end
  end
end