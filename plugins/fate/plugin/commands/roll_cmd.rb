module AresMUSH    
  module Fate
    class RollCmd
      include CommandHandler
  
      attr_accessor :roll_str
      
      def parse_args
        self.roll_str = titlecase_arg(cmd.args)
      end
            
      def required_args
        [self.roll_str]
      end
      
      def handle
        roll = Fate.roll_skill(enactor, self.roll_str)
        result = Fate.rating_name(roll)
        enactor_room.emit_ooc t('fate.roll_results', :name => enactor_name, :result => result, :roll => roll, :roll_str => self.roll_str)
      end
    end
  end
end