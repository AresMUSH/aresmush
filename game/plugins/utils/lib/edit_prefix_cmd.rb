module AresMUSH
  module Utils
    class EditPasswordCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :prefix
      
      def want_command?(client, cmd)
        cmd.root_is?("edit") && cmd.switch_is?("prefix")
      end
      
      def crack!
        self.prefix = trim_input(cmd.args)
      end

      def handle
        if (self.prefix.nil?)
          client.char.edit_prefix = nil
          message = t('edit.prefix_cleared')
        else
          client.char.edit_prefix = self.prefix
          message = t('edit.prefix_set')
        end
        
        client.char.save!
        client.emit_success message
      end
    end
  end
end
