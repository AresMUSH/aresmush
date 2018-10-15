module AresMUSH    
  module Fate
    class RollOpposedCmd
      include CommandHandler
  
      attr_accessor :roll_str1, :roll_str2, :target
      
      def parse_args
        return if !cmd.args
        
        self.roll_str1 = titlecase_arg(cmd.args.before(' vs '))
        
        second_section = cmd.args.after(' vs ') || ""
        self.target = titlecase_arg(second_section.before('/'))
        self.roll_str2 = titlecase_arg(second_section.after('/'))
      end
      
      def required_args
        [self.roll_str1, self.roll_str2, self.target]
      end
      
      def handle
        roll1 = Fate.roll_skill(enactor, self.roll_str1)
        
        char = Character.find_one_by_name(self.target)
        roll2 = Fate.roll_skill(enactor, self.roll_str2)
        
        result1 = Fate.rating_name(roll1)
        result2 = Fate.rating_name(roll2)
        
        if (roll1 == roll2)
          overall = t('fate.opposed_draw')
        elsif (roll1 > roll2)
          overall = t('fate.opposed_win', :name => enactor_name)
        else
          overall = t('fate.opposed_win', :name => self.target)
        end
        
        enactor_room.emit_ooc t('fate.opposed_roll_results', :name1 => enactor_name, 
           :name2 => self.target, 
           :roll_str1 => self.roll_str1,
           :roll_str2 => self.roll_str2,
           :roll1 => roll1,
           :roll2 => roll2,
           :result1 => result1,
           :result2 => result2,
           :overall => overall )
      end
    end
  end
end