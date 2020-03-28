module AresMUSH
  module Utils
    class EmojiCmd
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
        enactor.update(emoji_enabled: self.option.is_on?)
        client.emit_success t('utils.emoji_mode_set', :option => self.option)
      end
    end
  end
end