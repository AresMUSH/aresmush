module AresMUSH

  module FS3Skills
    class ResetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      include CommandWithoutSwitches

      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end

      def handle
        enactor.fs3_action_skills = {}
        enactor.fs3_aptitudes = {}
        enactor.fs3_interests = []
        enactor.fs3_expertise = []
        enactor.fs3_advantages = {}
        enactor.fs3_languages = []
        
        languages = Global.read_config("fs3skills", "starting_languages")
        if (languages)
          client.emit_ooc t('fs3skills.reset_languages')
          languages.each do |l|
            client.emit_success t('fs3skills.item_selected', :name => l)
            enactor.fs3_languages << l
          end
        end
        
        client.emit_ooc t('fs3skills.reset_aptitudes')
        FS3Skills.aptitude_names.each do |a|
          # Nil for client to avoid spam.
          FS3Skills.set_ability(nil, enactor, a, 2)
        end
        
        starting_skills = StartingSkills.get_groups_for_char(enactor)
        
        starting_skills.each do |k, v|
          set_starting_skills(k, v)
        end
        
        enactor.save
        client.emit_ooc t('fs3skills.reset_complete')
      end
      
      def set_starting_skills(group, skill_config)
        return if !skill_config
        
        notes = skill_config["notes"]
        if (notes)
          client.emit_ooc t('fs3skills.reset_group_notes', :group => group, :notes => notes)
        end

        skills = skill_config["skills"]
        return if !skills
        
        client.emit_ooc t('fs3skills.reset_for_group', :group => group)
        skills.each do |k, v|
          FS3Skills.set_ability(client, enactor, k, v)
        end
      end
    end
  end
end
