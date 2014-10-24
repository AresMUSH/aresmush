module AresMUSH
  module Handles
    class HandleOocCmd
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
        cmd.root_is?("handle") && cmd.switch_is?("ooc")
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_option
        return self.option.validate
      end
      
      def check_privacy
        if (client.char.handle_privacy != Handles.privacy_public &&
            self.option.is_on?)
          return t('handles.ooc_only_must_be_public') 
        else
          return nil
        end
      end
        
      def handle        
        client.char.handle_only = self.option.is_on?
        client.char.save
        if (self.option.is_on?)
          client.emit_ooc t('handles.set_ooc_only')
        else
          client.emit_ooc t('handles.clear_ooc_only')
        end
      end
    end
  end
end
