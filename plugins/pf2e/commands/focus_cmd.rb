module AresMUSH
  module Pf2e
    class FocusCmd
      include CommandHandler

      def handle
        sheet = Pf2e.sheet_for(enactor)
        if !sheet
          client.emit_failure t('pf2e.no_sheet')
          return
        end

        client.emit Pf2e.format_focus_status(sheet)
      end
    end
  end
end
