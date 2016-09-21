module AresMUSH
  module Status
    class PlayerBitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'playerbit'
        super
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle        
        client.char.is_playerbit = self.option.is_on?
        client.char.save
        client.emit_ooc self.option.is_on? ? t('status.set_playerbit_on') : t('status.set_playerbit_off')
      end
    end
  end
end
