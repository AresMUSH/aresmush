module AresMUSH
  module Custom
    class SpellModCmd
      #spell/learn <spell>
      include CommandHandler
      attr_accessor

      def self.learn_ability(client, char, name)
        ability = FS3Skills.find_ability(char, name)

        ability_type = FS3Skills.get_ability_type(name)
        if (ability_type == :advantage && !Global.read_config("fs3skills", "allow_advantages_xp"))
          client.emit_failure t('fs3skills.cant_learn_advantages_xp')
          return
        end

        if (!ability)
          FS3Skills.set_ability(client, char, name, 1)
        else

          error = FS3Skills.check_can_learn(char, name, ability.rating)
          if (error)
            client.emit_failure error
            return
          end

          if (!ability.can_learn?)
            time_left = ability.time_to_next_learn / 86400
            client.emit_failure t('fs3skills.cant_raise_yet', :days => time_left.ceil)
            return
          end

          ability.learn
          if (ability.learning_complete)
            ability.update(xp: 0)
            FS3Skills.set_ability(client, char, name, ability.rating + 1)
            message = t('fs3skills.xp_raised_job', :name => char.name, :ability => name, :rating => ability.rating + 1)
            category = Jobs.system_category
            Jobs.create_job(category, t('fs3skills.xp_job_title', :name => char.name), message, Game.master.system_character)
          else
            client.emit_success t('fs3skills.xp_spent', :name => name)
          end

          if (FS3Skills.skill_requires_training(ability))
            client.emit_ooc t('fs3skills.skill_requires_training', :name => name)
          end
        end
      end
    end
  end
end
