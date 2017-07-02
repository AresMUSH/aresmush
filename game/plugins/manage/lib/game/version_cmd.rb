module AresMUSH
  module Manage
    class VersionCmd
      include CommandHandler
      
      def allow_without_login
        true
      end
      
      def handle        
        template = BorderedDisplayTemplate.new t('manage.version', :version => AresMUSH.version)
        client.emit template.render
      end
    end
  end
end
