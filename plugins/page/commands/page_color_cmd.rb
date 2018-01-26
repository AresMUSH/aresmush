module AresMUSH
  module Page
    class PageColorCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        enactor.update(page_color: self.option)
        client.emit_success t('page.color_set', :option => self.option)
        AresCentral.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
