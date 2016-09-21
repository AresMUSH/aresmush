module AresMUSH

  module FS3Skills
    class ResetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      include CommandWithoutSwitches

      def check_chargen_locked
        Chargen::Api.check_chargen_locked(client.char)
      end

      def handle
        char = client.char
        char.fs3_action_skills = {}
        char.fs3_aptitudes = {}
        char.fs3_interests = []
        char.fs3_expertise = []
        char.fs3_advantages = {}
        char.fs3_languages = []
        
        languages = Global.read_config("fs3skills", "starting_languages")
        if (languages)
          client.emit_ooc t('fs3skills.reset_languages')
          languages.each do |l|
            client.emit_success t('fs3skills.item_selected', :name => l)
            char.fs3_languages << l
          end
        end
        
        client.emit_ooc t('fs3skills.reset_aptitudes')
        FS3Skills.aptitude_names.each do |a|
          # Nil for client to avoid spam.
          FS3Skills.set_ability(nil, client.char, a, 2)
        end
        
        starting_skills = StartingSkills.get_groups_for_char(client.char)
        
        starting_skills.each do |k, v|
          set_starting_skills(k, v)
        end
        
        char.save
        client.emit_ooc t('fs3skills.reset_complete')
      end
      
      def set_starting_skills(group, skill_config)
        return if skill_config.nil?
        
        notes = skill_config["notes"]
        if (notes)
          client.emit_ooc t('fs3skills.reset_group_notes', :group => group, :notes => notes)
        end

        skills = skill_config["skills"]
        return if skills.nil?
        
        client.emit_ooc t('fs3skills.reset_for_group', :group => group)
        skills.each do |k, v|
          FS3Skills.set_ability(client, client.char, k, v)
        end
      end
    end
  end
end
