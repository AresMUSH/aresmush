module AresMUSH
  module LuckGive
    class LuckGiveCmd
      #luck/give <name>=<reason>
      include CommandHandler
      attr_accessor :target_name, :reason

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.named(args.arg1)
        self.reason = args.arg2
      end

      def check_errors
        return t('luckgive.invalid_name') if !self.target
        max_luck = Global.read_config("fs3skills", "max_luck")
        return t('luckgive.max_luck', :name => self.target.name) if self.target.luck == max_luck
        return t('luckgive.not_enough_luck') if enactor.luck < 1
        return nil
      end

      def required_args
        [ self.target, self.reason ]
      end

      def handle
        date = Time.now.strftime("%Y-%m-%d")
        LuckRecord.create(date: date, character: self.target, reason: self.reason, from: enactor.name, to: self.target.name)
        LuckRecord.create(date: date, character: enactor, reason: self.reason, from: enactor.name, to: self.target.name)

        client.emit_success t('luckgive.given_luck', :name => self.target.name)
        message = t('luckgive.received_luck', :from => enactor.name)
        Login.emit_if_logged_in self.target, message
        Login.notify(self.target, :luck, message, nil)

        FS3Skills.modify_luck(self.target, 1)
        FS3Skills.modify_luck(enactor, -1)
      end

    end
  end
end