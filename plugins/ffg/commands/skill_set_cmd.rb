module AresMUSH    
  module Ffg
    class SkillSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :ability_name, :rating
      
      def parse_args
        # Admin version
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target_name = titlecase_arg(args.arg1)
          self.ability_name = titlecase_arg(args.arg2)
          self.rating = integer_arg(args.arg3)
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = enactor_name
          self.ability_name = titlecase_arg(args.arg1)
          self.rating = integer_arg(args.arg2)
        end
      end
      
      def required_args
        [self.target_name, self.ability_name, self.rating]
      end
      
      def check_archetype_and_career_set
        return t('ffg.must_set_archetype_and_career') if !enactor.ffg_archetype || !enactor.ffg_career
        return nil
      end
      
      def check_valid_rating
        return nil if Ffg.can_manage_abilities?(enactor) # Admin can set any rating.
        return nil if !self.rating
        return t('ffg.invalid_skill_rating') if self.rating > 5 || self.rating < 0
        if (!enactor.is_approved?)
          return Ffg.check_max_starting_rating(self.rating, 'max_cg_skill_rating')
        end
        return nil
      end
      
      def check_valid_ability
        return t('ffg.invalid_ability_name') if !Ffg.is_valid_skill_name?(self.ability_name)
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.target_name
        return nil if Ffg.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end     
      
      def check_chargen_locked
        return nil if Ffg.can_manage_abilities?(enactor)
        return nil if enactor.is_approved? # Can change skills after approval.
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          old_rating = Ffg.skill_rating(enactor, self.ability_name)
          
          if model.is_approved? && !Ffg.can_manage_abilities?(enactor) && old_rating > 0 && self.rating <= old_rating
            client.emit_failure t('ffg.cant_lower_skill_after_approval')
            return
          end
          
          if (self.rating > old_rating)
            xp_cost = Ffg.skill_xp_cost(model, self.ability_name, old_rating, self.rating)
          else
            xp_cost = -Ffg.skill_xp_cost(model, self.ability_name, self.rating, old_rating)
          end
          
          if (xp_cost > model.ffg_xp)
            client.emit_failure t('ffg.not_enough_xp')
            return
          end
          model.update(ffg_xp: model.ffg_xp - xp_cost)
          
          Ffg.set_skill(model, self.ability_name, self.rating)
         
          client.emit_success t('ffg.ability_set')
        end
      end
    end
  end
end