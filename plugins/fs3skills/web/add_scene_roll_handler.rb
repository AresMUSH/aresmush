module AresMUSH
  module FS3Skills
    class AddSceneRollRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        enactor = request.enactor
        roll_str = request.args[:roll_string]
        vs_roll1 = request.args[:vs_roll1] || ""
        vs_roll2 = request.args[:vs_roll2] || ""
        vs_name1 = request.args[:vs_name1] || ""
        vs_name2 = request.args[:vs_name2] || ""
        pc_name = request.args[:pc_name] || ""
        pc_skill = request.args[:pc_skill] || ""
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        # ------------------
        # VS ROLL
        # ------------------
        if (!vs_roll1.blank?)
          result = ClassTargetFinder.find(vs_name1, Character, enactor)
          model1 = result.target
          if (!model1 && !vs_roll1.is_integer?)
            vs_roll1 = "3"
          end
                                
          result = ClassTargetFinder.find(vs_name2, Character, enactor)
          model2 = result.target
          vs_name2 = model2 ? model2.name : vs_name2
                                
          if (!model2 && !vs_roll2.is_integer?)
            vs_roll2 = "3"
          end
          
          die_result1 = FS3Skills.parse_and_roll(model1, vs_roll1)
          die_result2 = FS3Skills.parse_and_roll(model2, vs_roll2)
          
          if (!die_result1 || !die_result2)
            return { error: t('fs3skills.unknown_roll_params') }
          end
          
          successes1 = FS3Skills.get_success_level(die_result1)
          successes2 = FS3Skills.get_success_level(die_result2)
            
          results = FS3Skills.opposed_result_title(vs_name1, successes1, vs_name2, successes2)

## Fatigue Stuff if first roller is PC
          if (!vs_roll1.is_integer?)

            ability_type1 = FS3Skills.get_ability_type(vs_roll1)

            rating1 = FS3Skills.ability_rating(model1, vs_roll1)
            if (ability_type1 == :advantage && rating1 == 0)
              return { error: "#{model1.name} does not possess that advantage." }
              return
            end

            current_fatigue1 = model1.fatigue.to_i
            if (current_fatigue1 > 6)
              fatigued1 = "yes"
            else
              fatigued1 = "no"
            end

            if (ability_type1 == :advantage && fatigued1 == "yes")
              return { error: "#{model1.name} is too fatigued to use any advantages." }
              return
            end

            rng1 = rand(9)
            ftg_ck1 = "yes"
  
            if (rng1 < 5)
              ftg_ck1 = "yes"
            else
              ftg_ck1 = "no"
            end

            if (ability_type1 == :advantage && ftg_ck1 == "yes")
              fatigue1 = model1.fatigue
              new_fatigue1 = fatigue1.to_i + 1
              model1.update(fatigue: new_fatigue1)
              Login.emit_ooc_if_logged_in(model1, "#{enactor.name} rolled your #{vs_roll1} and increased your fatigue.  Now at: #{new_fatigue1} / 7.")
              Login.notify(model1, "", "[#{enactor.name}] Rolling #{vs_roll1}, +1 Fatigue (#{new_fatigue1} / 7).", "")
            end

            if (ability_type1 == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{model1.name}'s #{vs_roll1}.  Fatigue increase: #{ftg_ck1}"
            end
          end
## End Fatigue Stuff if first roller is PC

## Fatigue Stuff if second roller is PC
          if (!vs_roll2.is_integer?)

            ability_type2 = FS3Skills.get_ability_type(vs_roll2)

            rating2 = FS3Skills.ability_rating(model2, vs_roll2)
            if (ability_type2 == :advantage && rating2 == 0)
              return { error: "#{model2.name} does not possess that advantage." }
              return
            end

            current_fatigue2 = model2.fatigue.to_i
            if (current_fatigue2 > 6)
              fatigued2 = "yes"
            else
              fatigued2 = "no"
            end

            if (ability_type2 == :advantage && fatigued2 == "yes")
              return { error: "#{model2.name} is too fatigued to use any advantages." }
              return
            end

            rng2 = rand(9)
            ftg_ck2 = "yes"
  
            if (rng2 < 5)
              ftg_ck2 = "yes"
            else
              ftg_ck2 = "no"
            end

            if (ability_type2 == :advantage && ftg_ck2 == "yes")
              fatigue2 = model2.fatigue
              new_fatigue2 = fatigue2.to_i + 1
              model2.update(fatigue: new_fatigue2)
              Login.emit_ooc_if_logged_in(model2, "#{enactor.name} rolled your #{vs_roll2} and increased your fatigue.  Now at: #{new_fatigue2} / 7.")
              Login.notify(model2, "", "[#{enactor.name}] Rolling #{vs_roll2}, +1 Fatigue (#{new_fatigue2} / 7).", "")
            end

            if (ability_type2 == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{model2.name}'s #{vs_roll2}.  Fatigue increase: #{ftg_ck2}"
            end
          end
## End Fatigue Stuff if second roller is PC
          
          message = t('fs3skills.opposed_roll_result', 
             :name1 => !model1 ? t('fs3skills.npc', :name => vs_name1) : model1.name,
             :name2 => !model2 ? t('fs3skills.npc', :name => vs_name2) : model2.name,
             :roll1 => vs_roll1,
             :roll2 => vs_roll2,
             :dice1 => FS3Skills.print_dice(die_result1),
             :dice2 => FS3Skills.print_dice(die_result2),
             :result => results)  

        # ------------------
        # PC ROLL
        # ------------------
        elsif (!pc_name.blank?)
          char = Character.find_one_by_name(pc_name) || enactor
          roll = FS3Skills.parse_and_roll(char, pc_skill)
          roll_result = FS3Skills.get_success_level(roll)
          success_title = FS3Skills.get_success_title(roll_result)

## Fatigue Stuff
          if (!roll_str.is_integer?)

            ability_type = FS3Skills.get_ability_type(pc_skill)

            rating = FS3Skills.ability_rating(char, pc_skill)
            if (ability_type == :advantage && rating == 0)
              return { error: "#{char.name} does not possess that advantage." }
              return
            end

            current_fatigue = char.fatigue.to_i
            if (current_fatigue > 6)
              fatigued = "yes"
            else
              fatigued = "no"
            end

            if (ability_type == :advantage && fatigued == "yes")
              return { error: "#{char.name} is too fatigued to use any advantages." }
              return
            end

            rng = rand(9)
            ftg_ck = "yes"

            if (rng < 5)
              ftg_ck = "yes"
            else
              ftg_ck = "no"
            end

            if (ability_type == :advantage && ftg_ck == "yes")
              fatigue = char.fatigue
              new_fatigue = fatigue.to_i + 1
              char.update(fatigue: new_fatigue)
              Login.emit_ooc_if_logged_in(char, "#{enactor.name} rolled your #{roll_str} and increased your fatigue.  Now at: #{new_fatigue} / 7.")
              Login.notify(char, "", "[#{enactor.name}] Rolling #{roll_str}, +1 Fatigue (#{new_fatigue} / 7).", "")
            end

            if (ability_type == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{char.name}'s #{roll_str}.  Fatigue increase: #{ftg_ck}"
            end
          end
## End Fatigue Stuff

          message = t('fs3skills.simple_roll_result', 
            :name => char.name,
            :roll => pc_skill,
            :dice => FS3Skills.print_dice(roll),
            :success => success_title
            )
            
        # ------------------
        # SELF ROLL
        # ------------------
        
        else
          roll = FS3Skills.parse_and_roll(enactor, roll_str)
          roll_result = FS3Skills.get_success_level(roll)
          success_title = FS3Skills.get_success_title(roll_result)

## Fatigue Stuff
          if (!roll_str.is_integer?)
            ability_type = FS3Skills.get_ability_type(roll_str)

            rating = FS3Skills.ability_rating(enactor, roll_str)
            if (ability_type == :advantage && rating == 0)
              return { error: "#{enactor.name} does not possess that advantage." }
              return
            end

            current_fatigue = enactor.fatigue.to_i
            if (current_fatigue > 6)
              fatigued = "yes"
            else
              fatigued = "no"
            end

            if (ability_type == :advantage && fatigued == "yes")
              return { error: "#{enactor.name} is too fatigued to use any advantages." }
              return
            end

            rng = rand(9)
            ftg_ck = "yes"

            if (rng < 5)
              ftg_ck = "yes"
            else
              ftg_ck = "no"
            end

            if (ability_type == :advantage && ftg_ck == "yes")
              fatigue = enactor.fatigue
              new_fatigue = fatigue.to_i + 1
              enactor.update(fatigue: new_fatigue)
              Login.emit_ooc_if_logged_in(enactor, "#{enactor.name} rolled your #{roll_str} and increased your fatigue.  Now at: #{new_fatigue} / 7.")
              Login.notify(enactor, "", "[#{enactor.name}] Rolling #{roll_str}, +1 Fatigue (#{new_fatigue} / 7).", "")
            end

            if (ability_type == :advantage)
              Global.logger.debug "#{enactor.name} rolling #{enactor.name}'s #{roll_str}.  Fatigue increase: #{ftg_ck}"
            end
          end
## End Fatigue Stuff

          message = t('fs3skills.simple_roll_result', 
            :name => enactor.name,
            :roll => roll_str,
            :dice => FS3Skills.print_dice(roll),
            :success => success_title
            )
        end
        
        Scenes.add_to_scene(scene, message, Game.master.system_character)
        
        if (scene.room)
          scene.room.emit message
        end
        
        {
        }
      end
    end
  end
end
