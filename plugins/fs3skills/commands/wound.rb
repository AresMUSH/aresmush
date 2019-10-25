module AresMUSH

  module FS3Skills
    class WoundCmd
      include CommandHandler
      
      attr_accessor :name, :roll_str, :private_roll

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)          
          self.name = trim_arg(args.arg1)
          self.roll_str = "Wound"
        else
          self.name = enactor_name        
          self.roll_str = "Wound"
        end
        self.private_roll = cmd.switch_is?("private")
      end
      
      def required_args
        [ self.name, self.roll_str ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          die_result = FS3Skills.parse_and_roll(model, self.roll_str)
          if !die_result
            client.emit_failure t('fs3skills.unknown_roll_params')
            return
          end
          
          success_level = FS3Skills.get_success_level(die_result)
          success_title = FS3Skills.get_success_title(success_level)
          message = t('fs3skills.adv_roll_result', 
            :name => model.name,
            :roll => self.roll_str,
            :dice => FS3Skills.print_dice(die_result),
            :success => success_title
          )
          FS3Skills.emit_results message, client, enactor_room, self.private_roll
        end
      end
    end
  end
end
