module AresMUSH
  module Utils
    class AutospaceCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :option
      
      def crack!
        self.option = trim_input(cmd.args)
      end

      def handle
        if (self.option.nil?)
          client.char.autospace = nil
          message = t('pose.autospace_cleared')
        else
          client.char.autospace = self.option
          message = t('pose.autospace_set', :option => self.option)
        end
        
        client.char.save!
        client.emit_success message
        
        Handles.warn_if_setting_linked_preference(client)
      end
    end
  end
end
