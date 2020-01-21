module AresMUSH

  module FS3Skills
    class RollCmd
      include CommandHandler
      
      attr_accessor :name, :roll_str, :private_roll

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)          
          self.name = titlecase_arg(args.arg1)
          self.roll_str = titlecase_arg(args.arg2)
        else
          self.name = enactor_name        
          self.roll_str = titlecase_arg(cmd.args)
        end
        self.private_roll = cmd.switch_is?("private")
      end
      
      def required_args
        [ self.name, self.roll_str ]
      end
      
      def handle
        char = Character.named(self.name)
        if (char)
          die_result = FS3Skills.parse_and_roll(char, self.roll_str)
          
        elsif (self.roll_str.is_integer?)
          die_result = FS3Skills.parse_and_roll(enactor, self.roll_str)
        else
          die_result = nil
        end
        
        if !die_result
          client.emit_failure t('fs3skills.unknown_roll_params')
          return
        end
        
        success_level = FS3Skills.get_success_level(die_result)
        success_title = FS3Skills.get_success_title(success_level)
        message = t('fs3skills.simple_roll_result', 
          :name => char ? char.name : "#{self.name} (#{enactor_name})",
          :roll => self.roll_str,
          :dice => FS3Skills.print_dice(die_result),
          :success => success_title
        )
        FS3Skills.emit_results message, client, enactor_room, self.private_roll
      end
    end
  end
end
