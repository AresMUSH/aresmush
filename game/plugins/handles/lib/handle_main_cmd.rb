module AresMUSH
  module Handles
    class HandleMainCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'handles'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("main")
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_option
        return self.option.validate
      end
      
      def handle        
        client.char.handle_main = self.option.is_on?
        client.char.save
        if (self.option.is_on?)
          client.emit_ooc t('handles.set_main')
          other_chars = Character.find_by_handle(client.char.handle)
          other_chars.each do |c|
            next if c == client.char
            c.handle_main = false
            c.save
          end
        else
          client.emit_ooc t('handles.set_main')
        end
      end
    end
  end
end
