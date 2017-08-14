module AresMUSH
  module Utils
    class SaveCmd
      include CommandHandler
      
      attr_accessor :text

      def parse_args
        self.text = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.text ]
      end
      
      def handle
        saved_text = enactor.utils_saved_text || []
        saved_text << self.text
        if (saved_text.count > 5)
          saved_text.shift
        end
        enactor.update(utils_saved_text: saved_text)

        client.emit_success t('save.text_saved')
      end
    end
  end
end
