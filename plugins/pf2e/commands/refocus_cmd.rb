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
          err = result[:error]
          if err == "pf2e.focus_already_full"
            client.emit_failure t('pf2e.focus_already_full',
                                 :current => result[:current],
                                 :max => result[:max])
          elsif err == "pf2e.focus_exhausted"
            client.emit_failure t('pf2e.focus_exhausted',
                                 :current => result[:current],
                                 :needed => result[:needed])
          else
            client.emit_failure t(err || 'pf2e.no_sheet')
          end
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
