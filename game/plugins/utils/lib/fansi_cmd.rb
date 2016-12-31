module AresMUSH
  module Utils
    class FansiCmd
      include CommandHandler

      attr_accessor :option

      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'color'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(fansi_on: self.option.is_on?)
        client.emit_success t('ansi.fansi_set', :option => self.option)
      end
    end
  end
end