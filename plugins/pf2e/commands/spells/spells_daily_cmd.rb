module AresMUSH
  module Pf2e
    class SpellsDailyCmd
      include CommandHandler

      def handle
        result = Pf2e.magic_daily_reset(enactor)
        unless result[:ok]
          client.emit_failure t(result[:error] || 'pf2e.no_sheet')
          return
        end
        focus_label = "#{result[:focus_points]}/#{result[:focus_max]}"
        client.emit_success t('pf2e.magic_daily_ok', :focus => focus_label)
        client.emit Pf2e.format_magic_status(enactor)
      end
    end
  end
end
