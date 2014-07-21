module AresMUSH
  module Utils
    class EditPasswordCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :password
      
      def want_command?(client, cmd)
        cmd.root_is?("edit") && cmd.switch_is?("password")
      end
      
      def crack!
        self.password = trim_input(cmd.args)
      end

      def handle
        if (self.password.nil?)
          client.char.edit_password = nil
          message = t('edit.password_cleared')
        else
          client.char.edit_password = self.password
          message = t('edit.password_set')
        end
        
        client.char.save!
        client.emit_success message
      end
    end
  end
end
