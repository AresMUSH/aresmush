module AresMUSH
  module Pf2e
    class Pf2eResetCmd
      include CommandHandler

      attr_accessor :name, :confirm

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = trim_arg(args.arg1)
        self.confirm = args.arg2 ? args.arg2.strip.downcase : nil
      end

      def required_args
        [ self.name ]
      end

      def check_permission
        return t('pf2e.staff_no_permission') unless Pf2e.can_manage_pf2e?(enactor)
        nil
      end

      def handle
        if self.confirm != "confirm"
          client.emit_failure t('pf2e.staff_reset_confirm', :name => self.name)
          return
        end

        result = Pf2e.staff_reset_sheet(enactor, self.name)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.staff_reset_ok', :name => result[:char].name)
      end
    end
  end
end
