module AresMUSH
  module Pf2e
    class RefocusCmd
      include CommandHandler

      def handle
        sheet = Pf2e.sheet_for(enactor)
        if !sheet
          client.emit_failure t('pf2e.no_sheet')
          return
        end

        result = Pf2e.refocus(sheet)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.refocus_ok',
                              :before => result[:before],
                              :after => result[:after],
                              :max => result[:max])
      end
    end
  end
end
