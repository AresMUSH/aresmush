module AresMUSH
  module Txt
    class TxtColorCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        enactor.update(txt_color: self.option)
        client.emit_success t('txt.color_set', :option => self.option)
      end
    end
  end
end
