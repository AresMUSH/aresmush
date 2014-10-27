module AresMUSH
  module Handles
    class HandleSyncCmd
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
        cmd.root_is?("handle") && cmd.switch_is?("sync")
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_option
        return self.option.validate
      end
      
      def check_slave
        return t('handles.cant_set_sync_on_master') if Global.api_router.is_master?
        return nil
      end
      
      def handle        
        client.char.handle_sync = self.option.is_on?
        client.char.save
        if (self.option.is_on?)
          client.emit_ooc t('handles.set_sync')
        else
          client.emit_ooc t('handles.clear_sync')
        end
      end
    end
  end
end
