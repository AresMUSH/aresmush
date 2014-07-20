module AresMUSH
  module Utils
    class AliasCmd
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
          client.char.save!
          client.emit_success t('autospace.autospace_cleared')
          return
        end
        
        client.char.autospace = self.option
        client.char.save!
        client.emit_success t('autospace.autospace_set', :option => self.option)
      end
    end
  end
end
