module AresMUSH
  module Utils
    class ScreenReaderCmd
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
        enactor.update(screen_reader: self.option.is_on?)
        client.emit_success t('utils.screen_reader_set', :option => self.option)
        AresCentral.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end