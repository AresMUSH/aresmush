module AresMUSH
  module Pf2e
    class MoneyWithdrawCmd
      include CommandHandler

      attr_accessor :amount_str

      def parse_args
        self.amount_str = cmd.args ? cmd.args.strip : nil
      end

      def required_args
        [ self.amount_str ]
      end

      def handle
        amount = Pf2e.parse_coin_string(self.amount_str)
        if amount.nil?
          client.emit_failure t('pf2e.money_bad_amount')
          return
        end

        result = Pf2e.society_withdraw(enactor, amount)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.money_withdraw_ok',
                             :amount => Pf2e.format_money(result[:withdrawn]),
                             :purse => Pf2e.format_money(result[:money]),
                             :account => Pf2e.format_money(result[:society_account]))
      end
    end
  end
end
