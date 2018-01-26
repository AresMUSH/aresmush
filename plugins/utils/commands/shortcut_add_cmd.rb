module AresMUSH
  module Utils
    class ShortcutAddCmd
      include CommandHandler
      
      attr_accessor :shortcut, :cmd

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.shortcut = trim_arg(args.arg1)
        self.cmd = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.shortcut, self.cmd ]
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
