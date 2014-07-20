module AresMUSH
  module Utils
    class AutospaceCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      
      attr_accessor :option
      
      def want_command?(client, cmd)
        cmd.root_is?("autospace")
      end
      
      def crack!
        self.option = trim_input(cmd.args)
      end

      def handle
        if (self.option.nil?)
          client.char.autospace = nil
          message = t('autospace.autospace_cleared')
        else
          client.char.autospace = self.option
          message = t('autospace.autospace_set', :option => self.option)
        end
        
        client.char.save!
        client.emit_success message
      end
    end
  end
end
