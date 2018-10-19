module AresMUSH    
  module Ffg
    class RollOpposedCmd
      include CommandHandler
      
      attr_accessor :roll_str, :opponent, :vs_ability
  
      def parse_args
        if (cmd.args)
         self.roll_str = cmd.args.before(' vs ')
         post_str = cmd.args.after(' vs ') || ""
         self.opponent = post_str.before('/')
         self.vs_ability = post_str.after('/')
       end
      end
      
      def require_args
        [ self.roll_str, self.opponent, self.vs_ability ]
      end
      
      
      def handle
        ClassTargetFinder.with_a_character(self.opponent, client, enactor) do |model|          
          if (!Ffg.is_valid_skill_name?(self.vs_ability))
            client.emit_failure t('ffg.invalid_ability_name')
            return
          end
          
          skill = Ffg.skill_rating(model, self.vs_ability)
          charac = Ffg.related_characteristic_rating(model, self.vs_ability)
          
          if (skill > charac)
            setback = skill - charac
            difficulty = skill
          else
            setback = charac - skill
            difficulty = charac
          end
          
          self.roll_str = "#{self.roll_str}+#{setback}S+#{difficulty}D"
          
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
end