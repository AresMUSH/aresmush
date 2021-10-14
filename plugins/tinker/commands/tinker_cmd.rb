module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
        template = BorderedDisplayTemplate.new "Some text to show.", "A Title"
        client.emit template.render
      end

    end
  end
end
