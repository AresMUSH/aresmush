module AresMUSH
  module Utils
    class SaveCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :text

      def crack!
        self.text = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.text ],
          help: 'save'
        }
      end
      
      def handle
        enactor.saved_text << self.text
        if (enactor.saved_text.count > 5)
          enactor.saved_text.shift
        end
        enactor.save

        client.emit_success t('save.text_saved')
      end
    end
  end
end
