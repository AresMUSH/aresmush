module AresMUSH
  module Utils
    class ShortcutsCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      
      def handle
        list = enactor.shortcuts.map { |k, v| "#{k}: #{v}"}
        client.emit BorderedDisplay.list list, t('shortcuts.shortcuts_title')
      end
    end
  end
end
