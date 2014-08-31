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
        char.fs3_languages = Global.config['fs3skills']['starting_languages']
        FS3Skills.attribute_names.each do |a|
          char.fs3_attributes[a] = { "rating" => 2 }
        end
        char.save
        client.emit_success t('fs3skills.reset_complete')
      end
    end
  end
end
