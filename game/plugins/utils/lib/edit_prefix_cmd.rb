module AresMUSH
  module Utils
    class EditPasswordCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :prefix
      
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
        
        client.char.save
        client.emit_success message
      end
    end
  end
end
