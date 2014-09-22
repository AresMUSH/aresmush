module AresMUSH

  module FS3Skills
    class SetLanguageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :add_lang

      def initialize
        self.required_args = ['name']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("language") && (cmd.switch_is?("add") || cmd.switch_is?("remove"))
      end

      def crack!
        self.name = titleize_input(cmd.args)
        self.add_lang = cmd.switch_is?("add")
      end
      
      def check_chargen_locked
        Chargen.check_chargen_locked(client.char)
      end
      
      def handle
        if (self.add_lang)
          if (FS3Skills.add_language(client, client.char, self.name))
            client.char.save
          end
        else
          if (!client.char.fs3_languages.include?(self.name))
            client.emit_failure t('fs3skills.language_not_selected')
            return
          end
          
          client.char.fs3_languages.delete self.name
          client.char.save
          client.emit_success t('fs3skills.language_removed', :name => self.name)
        end
      end
    end
  end
end
