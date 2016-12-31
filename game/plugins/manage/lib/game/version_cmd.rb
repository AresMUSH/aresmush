module AresMUSH
  module Manage
    class VersionCmd
      include CommandHandler
      include CommandWithoutArgs
      
      def allow_without_login
        true
      end
      
      def handle
        client.emit BorderedDisplay.text t('manage.version', :version => AresMUSH.version)
      end
    end
  end
end
