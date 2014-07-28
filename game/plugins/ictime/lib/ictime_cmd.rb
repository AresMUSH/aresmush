module AresMUSH
  module ICTime
    class ICTimeCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginWithoutArgs
           
      def want_command?(client, cmd)
        cmd.root_is?("ictime")
      end
      
      def handle
        client.emit BorderedDisplay.text t('ictime.ictime', :time => ICTime.ictime)
      end
    end
  end
end
