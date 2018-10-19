module AresMUSH    
  module Ffg
    class RollCmd
      include CommandHandler
      
      attr_accessor :roll_str
  
      def parse_args
         self.roll_str = trim_arg(cmd.args)
      end
      
      def require_args
        [ self.roll_str ]
      end
      
      
      def handle
        dice = Ffg.roll_ability(enactor, self.roll_str)
        
        if (!dice)
          client.emit_failure t('ffg.invalid_ability_name')
          return
        end
        
        results = Ffg.determine_outcome(dice)
        special = Ffg.special_roll_effects(results)
        
        if (results.successful)
          message = t('ffg.roll_successful', :dice => dice.join(' '), :special => special, :roll => self.roll_str, :char => enactor_name )
        else
          message = t('ffg.roll_failed', :dice => dice.join(' '), :special => special, :roll => self.roll_str, :char => enactor_name )
        end
        
        Rooms.emit_ooc_to_room enactor_room, message               
      end
    end
  end
end