module AresMUSH

  module FS3Skills
    class OpposedRollCmd
      include CommandHandler
      
      attr_accessor :name1, :name2, :roll_str1, :roll_str2

      def parse_args
        args = cmd.parse_args( /(?<name1>[^\/]+)\/(?<str1>.+) vs (?<name2>[^\/]+)?\/?(?<str2>.+)/ )
        self.roll_str1 = titlecase_arg(args.str1)
        self.roll_str2 = titlecase_arg(args.str2)
        self.name1 = trim_arg(args.name1)
        self.name2 = trim_arg(args.name2)
      end

      def required_args
        [ self.name1, self.roll_str1, self.roll_str2 ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name1, client, enactor) do |model1|
          
          if (self.name2)
            result = ClassTargetFinder.find(self.name2, Character, enactor)
            model2 = result.target
            self.name2 = !model2 ? self.name2 : model2.name
          end
                                  
          if (!model2 && !self.roll_str2.is_integer?)
            client.emit_failure t('fs3skills.numbers_only_for_npc_skills')
            return
          end
          
          die_result1 = FS3Skills.parse_and_roll(client, model1, self.roll_str1)
          die_result2 = FS3Skills.parse_and_roll(client, model2, self.roll_str2)
            
          return if !die_result1
          return if !die_result2
            
          successes1 = FS3Skills.get_success_level(die_result1)
          successes2 = FS3Skills.get_success_level(die_result2)
            
          results = FS3Skills.opposed_result_title(self.name1, successes1, self.name2, successes2)
            
          message = t('fs3skills.opposed_roll_result', 
          :name1 => model1.name,
          :name2 => !model2 ? t('fs3skills.npc', :name => self.name2) : model2.name,
          :roll1 => self.roll_str1,
          :roll2 => self.roll_str2,
          :dice1 => FS3Skills.print_dice(die_result1),
          :dice2 => FS3Skills.print_dice(die_result2),
          :result => results)  
            
          FS3Skills.emit_results message, client, enactor_room, false
        end
      end
    end
  end
end
