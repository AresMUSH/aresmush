module AresMUSH

  module Tinker
    
    class TinkerCmd
      include CommandHandler
            
      def parse_args
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
        template = LineWithTextTemplate.new("TEST")
        client.emit template.render
        client.emit_success "Done!"
      end

    end
  end
end
