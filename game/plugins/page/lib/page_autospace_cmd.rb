module AresMUSH
  module Page
    class PageAutospaceCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :option
      
      def crack!
        self.option = trim_input(cmd.args)
      end

      def handle
        
        if (!self.option)
          enactor.update(page_autospace: nil)
          message = t('page.autospace_cleared')
        else
          enactor.update(page_autospace: self.option)
          message = t('page.autospace_set', :option => self.option)
        end
        
        client.emit_success message
        Handles::Api.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
