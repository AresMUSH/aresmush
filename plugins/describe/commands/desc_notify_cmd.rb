module AresMUSH
  module Describe
    class DescNotifyCmd
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
        enactor.update(desc_notify: self.option.is_on?)
        client.emit_success t('describe.notify_set', :status => self.option)
      end
    end
  end
end
