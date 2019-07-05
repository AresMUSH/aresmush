module AresMUSH
  module LuckGive
    class LuckGiveCmd
      #luck/give <name>=<reason>
      include CommandHandler
      attr_accessor :target, :reason

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.target = Character.named(args.arg1)
       self.reason = args.arg2
      end

      def check_errors
        return t('luckgive.invalid_name') if !self.target
        return t('luckgive.not_enough_luck') if enactor.luck < 1
        return nil
      end

      def handle
        date = Time.now.strftime("%Y-%m-%d")

        LuckRecord.create(date: date, character: self.target, reason: self.reason, from: enactor.name)

        client.emit_success t('luckgive.given_luck', :name => self.target.name)
        message = t('luckgive.received_luck', :from => enactor.name)
        Login.emit_if_logged_in self.target, message

        FS3Skills.modify_luck(self.target, 1)
        FS3Skills.modify_luck(enactor, -1)
      end

    end
  end
end
