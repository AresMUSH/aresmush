module AresMUSH
  module Status
    class PlayerBitCmd
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
        enactor.update(is_playerbit: self.option.is_on?)
        client.emit_ooc self.option.is_on? ? t('status.set_playerbit_on') : t('status.set_playerbit_off')
      end
    end
  end
end
