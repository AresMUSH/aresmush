module AresMUSH
  module Pose
    class ReposeCatcherCmd
      include CommandHandler
      
      def handle
        client.emit_failure t('pose.repose_catcher')
      end
    end
  end
end
