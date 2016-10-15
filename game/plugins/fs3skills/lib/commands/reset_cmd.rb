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
        enactor.fs3_action_skills.each { |s| s.delete }
        enactor.fs3_attributes.each { |s| s.delete }
        enactor.fs3_background_skills.each { |s| s.delete }
        enactor.fs3_languages.each { |s| s.delete }
        enactor.fs3_hooks.each { |s| s.delete }
        
        languages = Global.read_config("fs3skills", "starting_languages")
        if (languages)
          client.emit_ooc t('fs3skills.reset_languages')
          languages.each do |l|
            FS3Skills.set_ability(client, enactor, l, 3)
          end
        end
        
        client.emit_ooc t('fs3skills.reset_aptitudes')
        FS3Skills.attr_names.each do |a|
          FS3Skills.set_ability(client, enactor, a, 2)
        end
        
        FS3Skills.action_skill_names.each do |a|
          FS3Skills.set_ability(client, enactor, a, 1)
        end
        
        starting_skills = StartingSkills.get_groups_for_char(enactor)
        
        starting_skills.each do |k, v|
          set_starting_skills(k, v)
        end
        
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
