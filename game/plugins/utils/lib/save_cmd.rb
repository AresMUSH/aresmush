module AresMUSH
  module Utils
    class SaveCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :text
      
      def initialize(client, cmd, enactor)
        self.required_args = ['text']
        self.help_topic = 'save'
        super
      end
      
      def crack!
        self.text = trim_input(cmd.args)
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
