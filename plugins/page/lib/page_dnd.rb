module AresMUSH
  module Page
    class PageDoNotDisturbCmd
      include CommandHandler

      attr_accessor :option
      
      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        [ self.option ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(page_do_not_disturb: self.option.is_on?)
        client.emit_success t('page.do_not_disturb_set', :status => self.option)
      end
    end
  end
end
