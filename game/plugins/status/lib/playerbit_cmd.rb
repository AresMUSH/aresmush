module AresMUSH
  module Status
    class PlayerBitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :option
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'playerbit'
        }
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
