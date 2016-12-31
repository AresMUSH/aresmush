module AresMUSH

  module FS3Skills
    class RollCmd
      include CommandHandler
      
      attr_accessor :name, :roll_str, :private_roll

      def crack!
        if (cmd.args =~ /\//)
          cmd.crack_args!(ArgParser.arg1_slash_arg2)          
          self.name = cmd.args.arg1
          self.roll_str = titleize_input(cmd.args.arg2)
        else
          self.name = enactor_name        
          self.roll_str = titleize_input(cmd.args)
        end
        self.private_roll = cmd.switch_is?("private")
      end
      
      def required_args
        {
          args: [ self.name, self.roll_str ],
          help: 'roll'
        }
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          die_result = FS3Skills.parse_and_roll(client, model, self.roll_str)
          return if !die_result
          
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
