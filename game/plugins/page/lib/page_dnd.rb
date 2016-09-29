module AresMUSH
  module Page
    class PageDoNotDisturbCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'page'
        super
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.do_not_disturb = (self.option.is_on?)
        enactor.save
        client.emit_success t('page.do_not_disturb_set', :status => self.option)
      end
    end
  end
end
