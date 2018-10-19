module AresMUSH    
  module Ffg
    class SpecRemoveCmd
      include CommandHandler
      
      attr_accessor :spec
      
      def parse_args
        self.spec = titlecase_arg cmd.args
      end
      
      def required_args
        [self.spec]
      end
      
      def check_archetype_and_career_set
        return t('ffg.must_set_archetype_and_career') if !enactor.ffg_archetype || !enactor.ffg_career
        return nil
      end
      
      def check_chargen_locked
        return nil if Ffg.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        if (!enactor.ffg_specializations.include?(self.spec))
          client.emit_failure t('ffg.dont_have_spec')
          return
        end
        
        xp_cost = -Ffg.specialization_xp_cost(enactor, self.spec, enactor.ffg_specializations.count - 1)
        enactor.update(ffg_xp: enactor.ffg_xp - xp_cost)
        
        specs = enactor.ffg_specializations
        specs.delete self.spec
        enactor.update(ffg_specializations: specs)
        
        Ffg.set_specialization_bonuses(enactor, self.spec)
        
        client.emit_success t('ffg.specialization_removed')
      end
    end
  end
end