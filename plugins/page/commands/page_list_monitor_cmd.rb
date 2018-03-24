module AresMUSH
  module Page
    class PageListMonitorCmd
      include CommandHandler

      def handle
        monitor = enactor.page_monitor || {}
        template = BorderedListTemplate.new(monitor.keys, t('page.page_monitoring'))
        client.emit template.render
      end
    end
  end
end
