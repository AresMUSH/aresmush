module AresMUSH
  module Help
    class BeginnerCmd
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
        enactor.update(is_beginner: self.option.is_on?)
        client.emit_success t('help.beginner_set', :option => self.option)
      end
    end
  end
end
