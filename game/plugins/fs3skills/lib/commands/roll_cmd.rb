module AresMUSH

  module FS3Skills
    class RollCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :roll_str, :private_roll

      def initialize(client, cmd, enactor)
        self.required_args = ['name', 'roll_str']
        self.help_topic = 'roll'
        super
      end
      
      def crack!
        if (cmd.args =~ /\//)
          cmd.crack_args!(CommonCracks.arg1_slash_arg2)          
          self.name = cmd.args.arg1
          self.roll_str = titleize_input(cmd.args.arg2)
        else
          self.name = enactor_name        
          self.roll_str = titleize_input(cmd.args)
        end
        self.private_roll = cmd.switch_is?("private")
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          die_result = FS3Skills.parse_and_roll(client, model, self.roll_str)
          return if die_result.nil?
          
          success_level = FS3Skills.get_success_level(die_result)
          success_title = FS3Skills.get_success_title(success_level)
          message = t('fs3skills.simple_roll_result', 
            :name => model.name,
            :roll => self.roll_str,
            :dice => FS3Skills.print_dice(die_result),
            :success => success_title
          )
          FS3Skills.emit_results message, client, model.room, self.private_roll
        end
      end
    end
  end
end
