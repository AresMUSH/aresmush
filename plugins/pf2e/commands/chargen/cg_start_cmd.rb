module AresMUSH
  module Pf2e
    class CgStartCmd
      include CommandHandler

      def handle
        result = Pf2e.cg_ensure_sheet(enactor)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.cg_sheet_ready')
      end
    end
  end
end
