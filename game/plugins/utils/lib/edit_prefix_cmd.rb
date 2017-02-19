module AresMUSH
  module Utils
    class EditPasswordCmd
      include CommandHandler
      
      attr_accessor :prefix
      
      def parse_args
        self.prefix = trim_arg(cmd.args)
      end

      def handle
        if (!self.prefix)
          enactor.update(utils_edit_prefix: nil)
          message = t('edit.prefix_cleared')
        else
          enactor.update(utils_edit_prefix: self.prefix)
          message = t('edit.prefix_set')
        end
        
        client.emit_success message
      end
    end
  end
end
