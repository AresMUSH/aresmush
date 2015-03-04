module AresMUSH

  module FS3Skills
    class RemoveQuirkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("quirk") && cmd.switch_is?("remove")
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_chargen_locked
        Chargen.check_chargen_locked(client.char)
      end
            
      def handle
        if (!client.char.fs3_quirks.has_key?(self.name))
          client.emit_failure t('fs3skills.quirk_not_selected')
          return
        end
          
        client.char.fs3_quirks.delete self.name
        client.char.save
        client.emit_success t('fs3skills.quirk_removed', :name => self.name)
      end
    end
  end
end
