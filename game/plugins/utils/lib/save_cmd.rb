module AresMUSH
  module Utils
    class SaveCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :text
      
      def initialize
        self.required_args = ['text']
        self.help_topic = 'save'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("save")
      end
      
      def crack!
        self.text = trim_input(cmd.args)
      end

      def handle
        client.char.saved_text << self.text
        if (client.char.saved_text.count > 5)
          client.char.saved_text.shift
        end
        client.char.save

        client.emit_success t('save.text_saved')
      end
    end
  end
end
