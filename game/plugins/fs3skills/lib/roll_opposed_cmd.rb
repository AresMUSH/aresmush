module AresMUSH

  module FS3Skills
    class OpposedRollCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name1, :name2, :roll_str1, :roll_str2

      def initialize
        self.required_args = ['name1', 'name2', 'roll_str1', 'roll_str2']
        self.help_topic = 'roll'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("roll") && cmd.args =~ / vs /
      end

      def crack!
        
        cmd.crack_args!( /(?<name1>[^\/]+)\/(?<str1>.+) vs (?<name2>[^\/]+)\/(?<str2>.+)/ )
        self.roll_str1 = titleize_input(cmd.args.str1)
        self.roll_str2 = titleize_input(cmd.args.str2)
        self.name1 = cmd.args.name1
        self.name2 = cmd.args.name2
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name1, client) do |model1|
          ClassTargetFinder.with_a_character(self.name2, client) do |model2|
            
            roll_params1 = FS3Skills.parse_roll_params self.roll_str1
            roll_params2 = FS3Skills.parse_roll_params self.roll_str2
          
            if (roll_params1.nil? || roll_params2.nil?)
              client.emit_failure t('fs3skills.unknown_roll_params')
              return
            end
          
            die_result1 = FS3Skills.roll_ability(client, model1, roll_params1)
            die_result2 = FS3Skills.roll_ability(client, model2, roll_params2)
            
            successes1 = FS3Skills.get_success_level(die_result1)
            successes2 = FS3Skills.get_success_level(die_result2)
            
            results = FS3Skills.opposed_result_title(name1, successes1, name2, successes2)
            
            message = t('fs3skills.opposed_roll_result', 
            :name1 => self.name1,
            :name2 => self.name2,
            :roll1 => self.roll_str1,
            :roll2 => self.roll_str2,
            :dice1 => FS3Skills.print_dice(die_result1),
            :dice2 => FS3Skills.print_dice(die_result2),
            :result => results)  
            
            FS3Skills.emit_results message, client, client.room, false
          end
        end
      end
    end
  end
end
