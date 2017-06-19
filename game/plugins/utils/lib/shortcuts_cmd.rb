module AresMUSH
  module Utils
    class ShortcutsCmd
      include CommandHandler
      
      
      def handle
        list = enactor.shortcuts.map { |k, v| "#{k}: #{v}"}
        template = BorderedListTemplate.new list, t('shortcuts.shortcuts_title')
        client.emit template.render
      end
    end
  end
end
