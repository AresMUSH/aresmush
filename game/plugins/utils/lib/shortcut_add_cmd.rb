module AresMUSH
  module Utils
    class ShortcutAddCmd
      include CommandHandler
      
      attr_accessor :shortcut, :cmd

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.shortcut = trim_input(cmd.args.arg1)
        self.cmd = trim_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.shortcut, self.cmd ],
          help: 'shortcuts'
        }
      end
      
      def handle
        shortcuts = enactor.shortcuts
        shortcuts[self.shortcut.downcase] = self.cmd
        enactor.update(shortcuts: shortcuts)

        client.emit_success t('shortcuts.shortcut_added')
      end
    end
  end
end
