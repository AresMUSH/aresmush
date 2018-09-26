module AresMUSH
  module Custom
    class LuckRequestCmd
    # luck/request <reason>
      include CommandHandler

      attr_accessor :reason

      def handle
        reason = cmd.args
        Jobs.create_job("SYS", "Luck Request", reason, enactor)
      end

    end
  end
end
