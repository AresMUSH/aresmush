module AresMUSH
  module Utils
    class GrayscaleCmd
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
        client.emit_success t('ansi.grayscale_mode_set', :option => self.option)
      end
    end
  end
end