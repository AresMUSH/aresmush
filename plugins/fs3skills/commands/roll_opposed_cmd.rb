module AresMUSH

  module FS3Skills
    class OpposedRollCmd
      include CommandHandler
      
      attr_accessor :name1, :name2, :roll_str1, :roll_str2, :private_roll

      def parse_args
        args = cmd.parse_args( /(?<name1>[^\/]+)\/(?<str1>.+) vs (?<name2>[^\/]+)?\/?(?<str2>.+)/ )
        self.roll_str1 = titlecase_arg(args.str1)
        self.roll_str2 = titlecase_arg(args.str2)
        self.name1 = titlecase_arg(args.name1)
        self.name2 = titlecase_arg(args.name2)
        self.private_roll = cmd.switch_is?("private")
      end

      def required_args
        [ self.name1, self.roll_str1, self.roll_str2 ]
      end
      
      def handle
        
        result = ClassTargetFinder.find(self.name1, Character, enactor)
        model1 = result.target
        if (!model1 && !self.roll_str1.is_integer?)
          client.emit_failure t('fs3skills.numbers_only_for_npc_skills')
          return
        end
                                
        if (self.name2)
          result = ClassTargetFinder.find(self.name2, Character, enactor)
          model2 = result.target
          self.name2 = !model2 ? self.name2 : model2.name
        end
                                
        if (!model2 && !self.roll_str2.is_integer?)
          client.emit_failure t('fs3skills.numbers_only_for_npc_skills')
          return
        end
          
        die_result1 = FS3Skills.parse_and_roll(model1, self.roll_str1)
        die_result2 = FS3Skills.parse_and_roll(model2, self.roll_str2)
          
        if (!die_result1 || !die_result2)
          client.emit_failure t('fs3skills.unknown_roll_params')
          return
        end
          
        successes1 = FS3Skills.get_success_level(die_result1)
        successes2 = FS3Skills.get_success_level(die_result2)
            
        results = FS3Skills.opposed_result_title(self.name1, successes1, self.name2, successes2)

## Fatigue Stuff for roll 1
          if (!self.roll_str1.is_integer?)
            ability_type1 = FS3Skills.get_ability_type(roll_str1)
            if (ability_type1 == "nil")
              ability_type1 = "no"
            end

            rating1 = FS3Skills.ability_rating(model1, self.roll_str1)
            if (ability_type1 == :advantage && rating1 == 0)
              client.emit_failure("#{model1.name} does not possess that advantage.")
              return
            end

            current_fatigue1 = model1.fatigue.to_i
            if (current_fatigue1 > 6)
              fatigued1 = "yes"
            else
              fatigued1 = "no"
            end

            if (ability_type1 == :advantage && fatigued1 == "yes" && self.private_roll == false)
              client.emit_failure("#{model1.name} is too fatigued to use any advantages.")
              return
            end

            rng1 = rand(9)
            ftg_ck1 = "yes"

            if (rng1 < 5)
              ftg_ck1 = "yes"
            else
              ftg_ck1 = "no"
            end

            if (ability_type1 == :advantage && ftg_ck1 == "yes" && self.private_roll == false)
              fatigue1 = model1.fatigue
              new_fatigue1 = fatigue1.to_i + 1
              model1.update(fatigue: new_fatigue1)
              Login.emit_ooc_if_logged_in(model1, "#{enactor.name} rolled your #{roll_str1} and increased your fatigue.  Now at: #{new_fatigue1} / 7.")
            end

            if (ability_type1 == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{model1.name}'s #{roll_str1}.  Fatigue increase: #{ftg_ck1}"
            end
          end
## End Fatigue Stuff for roll 1
        
## Fatigue Stuff for roll 2
          if (!self.roll_str2.is_integer?)
            ability_type2 = FS3Skills.get_ability_type(roll_str2)
            if (ability_type2 == "nil")
              ability_type2 = "no"
            end

            rating2 = FS3Skills.ability_rating(model2, roll_str2)
            if (ability_type2 == :advantage && rating2 == 0)
              client.emit_failure("#{model2.name} does not possess that advantage.")
              return
            end

            current_fatigue2 = model2.fatigue.to_i
            if (current_fatigue2 > 6)
              fatigued2 = "yes"
            else
              fatigued2 = "no"
            end

            if (ability_type2 == :advantage && fatigued2 == "yes" && self.private_roll == false)
              client.emit_failure("#{model2.name} is too fatigued to use any advantages.")
              return
            end

            rng2 = rand(9)
            ftg_ck2 = "yes"

            if (rng2 < 5)
              ftg_ck2 = "yes"
            else
              ftg_ck2 = "no"
            end

            if (ability_type2 == :advantage && ftg_ck2 == "yes" && self.private_roll == false)
              fatigue2 = model2.fatigue
              new_fatigue2 = fatigue2.to_i + 1
              model2.update(fatigue: new_fatigue2)
              Login.emit_ooc_if_logged_in(model2, "#{enactor.name} rolled your #{roll_str2} and increased your fatigue.  Now at: #{new_fatigue2} / 7.")
            end

            if (ability_type2 == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{model2.name}'s #{roll_str2}.  Fatigue increase: #{ftg_ck2}"
            end
          end
## End Fatigue Stuff for roll 2
          
        message = t('fs3skills.opposed_roll_result', 
           :name1 => !model1 ? t('fs3skills.npc', :name => self.name1) : model1.name,
           :name2 => !model2 ? t('fs3skills.npc', :name => self.name2) : model2.name,
           :roll1 => self.roll_str1,
           :roll2 => self.roll_str2,
           :dice1 => FS3Skills.print_dice(die_result1),
           :dice2 => FS3Skills.print_dice(die_result2),
           :result => results)  
          
        FS3Skills.emit_results message, client, enactor_room, self.private_roll
      end
    end
  end
end
