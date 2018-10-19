module AresMUSH    
  module Ffg
    class ResetCmd
      include CommandHandler
      
      attr_accessor :type, :career
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.type = titlecase_arg args.arg1
        self.career = titlecase_arg args.arg2
      end
      
      def required_args
        [self.type, self.career]
      end
      
      def check_valid_values
        return t('ffg.invalid_archetype') if !Ffg.is_valid_archetype?(self.type)
        return t('ffg.invalid_career') if !Ffg.is_valid_career?(self.career)
        return nil
      end
      
      def check_chargen_locked
        return nil if Ffg.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        enactor.update(ffg_archetype: self.type)
        enactor.update(ffg_career: self.career)
        enactor.update(ffg_specializations: [])
        enactor.delete_ffg_abilities
        
        config = Ffg.find_archetype_config(self.type)
        (config['characteristics'] || {}).each do |name, rating|
          Ffg.set_characteristic(enactor, name, rating)
        end
        (config['skills'] || []).each do |name|
          Ffg.set_skill(enactor, name, 1)
        end
        (config['talents'] || []).each do |name|
          talent = Ffg.find_talent(enactor, name)
          if (!talent)
            talent_config = Ffg.find_talent_config(name)
            FfgTalent.create(name: name, character: enactor, rating: talent_config['ranked'] ? 1 : 0)
          end
        end
        
        bonus_xp = Global.read_config('ffg', 'bonus_xp')
        career_xp = Global.read_config('ffg', 'career_skill_xp')
        enactor.update(ffg_xp: config['xp'] + bonus_xp + career_xp)
        
        config = Ffg.find_career_config(self.career)
        (config['skills'] || []).each do |name|
          Ffg.set_skill(enactor, name, 1)
        end
        
        Ffg.set_archetype_bonuses(enactor, self.type)
        Ffg.set_career_bonuses(enactor, self.career)
        Ffg.update_thresholds(enactor)
        
        client.emit_success t('ffg.archetype_set')
      end
    end
  end
end