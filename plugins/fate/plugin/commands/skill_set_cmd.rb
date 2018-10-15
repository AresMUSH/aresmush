module AresMUSH    
  module Fate
    class SkillSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :skill_name, :rating
      
      def parse_args
        # Admin version
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target_name = titlecase_arg(args.arg1)
          self.skill_name = titlecase_arg(args.arg2)
          self.rating = downcase_arg(args.arg3)
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = enactor_name
          self.skill_name = titlecase_arg(args.arg1)
          self.rating = downcase_arg(args.arg2)
        end
        self.rating = Fate.name_to_rating(self.rating)
      end
      
      def required_args
        [self.target_name, self.skill_name, self.rating]
      end
      
      def check_valid_rating
        return nil if self.rating == '0'
        return t('fate.invalid_rating') if !Fate.is_valid_skill_rating?(self.rating)
        return nil
      end
      
      def check_valid_ability
        return t('cortex.invalid_skill_name') if !Fate.is_valid_skill_name?(self.skill_name)
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.target_name
        return nil if Fate.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end     
      
      def check_chargen_locked
        return nil if Fate.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          skills = model.fate_skills || {}
          rating = skills[self.skill_name]
          
          if (rating == 0)
            skills.delete self.skill_name
            client.emit_success t('fate.skill_removed')
          else
            skills[self.skill_name] = self.rating
            client.emit_success t('fate.skill_set')
          end
          model.update(fate_skills: skills)
        end
      end
    end
  end
end