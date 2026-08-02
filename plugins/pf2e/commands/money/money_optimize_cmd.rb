module AresMUSH
  module Pf2e
    class MoneyOptimizeCmd
      include CommandHandler

      attr_accessor :amount_str

      def parse_args
        self.amount_str = cmd.args ? cmd.args.strip : nil
      end

      def required_args
        [ self.amount_str ]
      end

      def handle
        target = Pf2e.parse_coin_string(self.amount_str)
        if target.nil?
          client.emit_failure t('pf2e.money_bad_amount')
          return
        end

        result = Pf2e.optimize_purse(enactor, target)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        if result[:deposited_cp] > 0
          client.emit_success t('pf2e.money_optimize_ok',
                               :kept => Pf2e.format_money(result[:money]),
                               :deposited => Pf2e.format_money(result[:deposited]),
                               :account => Pf2e.format_money(result[:society_account]),
                               :coins => result[:coin_count])
        else
          client.emit_success t('pf2e.money_optimize_rebreak_only',
                               :kept => Pf2e.format_money(result[:money]),
                               :coins => result[:coin_count])
        end
      end
    end
  end
end
