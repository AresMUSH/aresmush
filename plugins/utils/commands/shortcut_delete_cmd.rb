module AresMUSH
  module Utils
    class ShortcutDeleteCmd
      include CommandHandler
      
      attr_accessor :shortcut

      def parse_args
        self.shortcut = cmd.args ? trim_arg(cmd.args).downcase : nil
      end
      
      def required_args
        [ self.shortcut ]
      end
      
      def handle
        shortcuts = enactor.shortcuts
        
        if (!shortcuts.has_key?(self.shortcut))
          client.emit_failure t('shortcuts.shortcut_does_not_exist')
          return
        end
        
        shortcuts.delete self.shortcut
        enactor.update(shortcuts: shortcuts)

        client.emit_success t('shortcuts.shortcut_deleted')
      end
    end
  end
end
