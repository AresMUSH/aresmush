module AresMUSH
  module Pf2e
    class Pf2eSetCmd
      include CommandHandler

      attr_accessor :name, :path

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.path = args.arg2 ? args.arg2.strip : nil
      end

      def required_args
        [ self.name, self.path ]
      end

      def check_permission
        return t('pf2e.staff_no_permission') unless Pf2e.can_manage_pf2e?(enactor)
        nil
      end

      def handle
        result = Pf2e.staff_set(enactor, self.name, self.path)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.staff_set_ok',
                             :name => result[:char].name,
                             :summary => result[:summary])
      end
    end
  end
end
