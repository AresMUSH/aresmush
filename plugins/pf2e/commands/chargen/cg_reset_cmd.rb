module AresMUSH
  module Pf2e
    class CgResetCmd
      include CommandHandler

      attr_accessor :confirmed

      def parse_args
        self.confirmed = cmd.args.to_s.strip.downcase == "confirm"
      end

      def handle
        unless self.confirmed
          client.emit_failure t('pf2e.cg_reset_confirm')
          return
        end

        result = Pf2e.cg_reset_sheet(enactor)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.cg_reset_ok')
      end
    end
  end
end
