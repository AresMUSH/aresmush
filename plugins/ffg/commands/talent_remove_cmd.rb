module AresMUSH    
  module Ffg
    class TalentRemoveCmd
      include CommandHandler
      
      attr_accessor :target_name, :ability_name
      
      def parse_args
        # Admin version
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.ability_name = titlecase_arg(args.arg2)
        else
          self.target_name = enactor_name
          self.ability_name = titlecase_arg(cmd.args)
        end
      end
      
      def required_args
        [self.target_name, self.ability_name]
      end
      
      def check_archetype_and_career_set
        return t('ffg.must_set_archetype_and_career') if !enactor.ffg_archetype || !enactor.ffg_career
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.target_name
        return nil if Ffg.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end     
      
      def check_chargen_locked
        return nil if Ffg.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          talent = Ffg.find_talent(model, self.ability_name)
          
          if (!talent)
            client.emit_failure t('ffg.ability_not_found')
            return
          end
          
          talent_config = Ffg.find_talent_config(self.ability_name)
          tier = talent_config['tier']
          if (talent_config['ranked'])
            tier = tier + talent.rating - 1
          end
          
          if (!Ffg.talent_tree_balanced_for_remove(model, tier))
            client.emit_failure t('ffg.talent_remove_unbalanced')
            return
          end
          
          xp_cost = -Ffg.talent_xp_cost(self.ability_name, talent.rating - 1, talent.rating)
          model.update(ffg_xp: model.ffg_xp - xp_cost)
          
          if (talent.rating > 1)
            talent.update(rating: talent.rating - 1)
            client.emit_success t('ffg.talent_tier_lowered', :tier => talent.rating)
          else
            talent.delete
            client.emit_success t('ffg.ability_removed')
          end
        end
      end
    end
  end
end