module AresMUSH
  module Status
    class OOCCatcherCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("ooc") && cmd.args.nil?
      end
      
      def handle        
        client.emit_failure t('status.perhaps_you_meant_offstage')
      end
    end
  end
end
