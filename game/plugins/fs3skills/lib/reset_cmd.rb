module AresMUSH

  module FS3Skills
    class ResetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      include PluginWithoutSwitches
            
      def want_command?(client, cmd)
        cmd.root_is?("reset")
      end

      def handle
        char = client.char
        char.fs3_attributes = {}
        char.fs3_action_skills = {}
        char.fs3_background_skills = {}
        char.fs3_quirks = []
        char.fs3_languages = []
        
        languages = Global.config['fs3skills']['starting_languages']
        if (languages)
          client.emit_ooc t('fs3skills.reset_languages')
          languages.each do |l|
            client.emit_success t('fs3skills.language_selected', :name => l)
            char.fs3_languages << l
          end
        end
        
        client.emit_ooc t('fs3skills.reset_attributes')
        FS3Skills.attribute_names.each do |a|
          FS3Skills.set_ability(client, client.char, a, 2)
        end
        
        config = Global.config['fs3skills']['starting_skills']
        config.each do |k, v|
          group_config = get_group_config(k, v)
          set_starting_skills(k, group_config)
        end
        
        char.save
        client.emit_ooc t('fs3skills.reset_complete')
      end
      
      def get_group_config(group, config)
        return config if group == "Everyone" 
        group_val = client.char.groups[group]
        return nil if group_val.nil?
        key = config.keys.find { |k| k.downcase == group_val.downcase }
        config[key]
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
