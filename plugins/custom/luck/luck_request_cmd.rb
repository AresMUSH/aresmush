module AresMUSH
  module Custom
    class LuckRequestCmd
    # luck/request <reason>
      include CommandHandler

      attr_accessor :reason

      def handle
        reason = cmd.args
        Jobs.create_job("LUCK", "Luck Request", reason, enactor)
        client.emit_success t('custom.luck_requested')
      end

    end
  end
end
