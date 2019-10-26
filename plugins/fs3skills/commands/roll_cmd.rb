module AresMUSH

  module FS3Skills
    class RollCmd
      include CommandHandler
      
      attr_accessor :name, :roll_str, :private_roll

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)          
          self.name = trim_arg(args.arg1)
          self.roll_str = titlecase_arg(args.arg2)
        else
          self.name = enactor_name        
          self.roll_str = titlecase_arg(cmd.args)
        end
        self.private_roll = cmd.switch_is?("private")
      end
      
      def required_args
        [ self.name, self.roll_str ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          die_result = FS3Skills.parse_and_roll(model, self.roll_str)
          if !die_result
            client.emit_failure t('fs3skills.unknown_roll_params')
            return
          end

## Fatigue Stuff
          if (!roll_str.is_integer?)
            ability_type = FS3Skills.get_ability_type(roll_str)

            rating = FS3Skills.ability_rating(model, roll_str)
            if (ability_type == :advantage && rating == 0)
              client.emit_failure("#{model.name} does not possess that advantage.")
              return
            end

            current_fatigue = model.fatigue.to_i
            if (current_fatigue > 6)
              fatigued = "yes"
            else
              fatigued = "no"
            end

            if (ability_type == :advantage && fatigued == "yes" && self.private_roll == false)
              client.emit_failure("#{model.name} is too fatigued to use any advantages.")
              return
            end

            rng = rand(9)
            ftg_ck = "yes"

            if (rng < 5)
              ftg_ck = "yes"
            else
              ftg_ck = "no"
            end

            if (ability_type == :advantage && ftg_ck == "yes" && self.private_roll == false)
              fatigue = model.fatigue
              new_fatigue = fatigue.to_i + 1
              model.update(fatigue: new_fatigue)
              Login.emit_ooc_if_logged_in(model, "#{enactor.name} rolled your #{roll_str} and increased your fatigue.  Now at: #{new_fatigue} / 7.")
              Login.notify(model, :scene, "#{enactor.name} rolled your #{roll_str} and increased your fatigue.  Now at: #{new_fatigue} / 7.", scene.id)
            end

            if (ability_type == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{model.name}'s #{roll_str}.  Fatigue increase: #{ftg_ck}"
            end
          end
## End Fatigue Stuff
          
          success_level = FS3Skills.get_success_level(die_result)
          success_title = FS3Skills.get_success_title(success_level)
          message = t('fs3skills.simple_roll_result', 
            :name => model.name,
            :roll => self.roll_str,
            :dice => FS3Skills.print_dice(die_result),
            :success => success_title
          )
          FS3Skills.emit_results message, client, enactor_room, self.private_roll
        end
      end
    end
  end
end
