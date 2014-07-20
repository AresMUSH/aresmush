module AresMUSH
  module Manage
    class VersionCmd
      include Plugin
      include PluginWithoutArgs
      include PluginWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("version")
      end
      
      def handle
        client.emit BorderedDisplay.text t('manage.version', :version => AresMUSH.version)
      end
    end
  end
end
