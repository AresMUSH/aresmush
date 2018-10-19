module AresMUSH    
  module Ffg
    class TalentAddCmd
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
        return nil if enactor.is_approved?
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          
          talent_config = Ffg.find_talent_config(self.ability_name)
          if (!talent_config)
            client.emit_failure t('ffg.invalid_ability_name')
            return
          end
          
          talent = Ffg.find_talent(model, self.ability_name)
          
          is_ranked = talent_config['ranked']
          is_force = talent_config['force_power']
          specs = talent_config['specializations']
          prereq = talent_config['prereq']
          tier = talent_config['tier']
            
          if (talent && !is_ranked)
            client.emit_failure t('ffg.already_have_talent')
            return
          end
            
          if (talent && is_ranked && talent.rating >= 5)
            client.emit_failure t('ffg.talent_at_maximum')
            return
          end
        
          if (is_force && !Ffg.is_force_user?(model))
            client.emit_failure t('ffg.talent_force_restricted')
            return
          end
          
          if (specs && ((specs & model.ffg_specializations).empty?))
            client.emit_failure t('ffg.missing_talent_specialization', :specs => specs.join(", "))
            return
          end
          
          if (prereq && !Ffg.find_talent(model, prereq))
            client.emit_failure t('ffg.missing_talent_prereq', :prereq => prereq)
            return
          end
          
          old_rating = talent ? talent.rating : 0
          
          if (!Ffg.talent_tree_balanced_for_add(model, talent ? talent.rating_plus_tier + 1 : tier))
            client.emit_failure t('ffg.talent_add_unbalanced')
            return
          end
          
          xp_cost = Ffg.talent_xp_cost(self.ability_name, old_rating, old_rating + 1)
          if (xp_cost > model.ffg_xp)
            client.emit_failure t('ffg.not_enough_xp')
            return
          end
          model.update(ffg_xp: model.ffg_xp - xp_cost)
          
          if (talent)
            talent.update(rating: talent.rating + 1)
            client.emit_success t('ffg.talent_tier_raised', :tier => talent.rating)
          else
            FfgTalent.create(name: self.ability_name, rating: 1, tier: tier, ranked: is_ranked, character: model)
            client.emit_success t('ffg.talent_added')
          end
        end
      end
    end
  end
end