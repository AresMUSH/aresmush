module AresMUSH
  module Manage
    class BlocksListCmd
      include CommandHandler      
      include TemplateFormatters
      
      def check_syntax
        return t('dispatcher.invalid_syntax', :cmd => cmd.root_plus_switch) if cmd.args        
      end

      def handle
        template = BlocksTemplate.new enactor
        client.emit template.render
      end
      
    end
  end
end
