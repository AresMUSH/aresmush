module AresMUSH
  module LuckGive
    class LuckGiveCmd
      #luck/give <name>=<reason>
      include CommandHandler
      attr_accessor :target_name, :reason

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.target_name = args.arg1
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
        ClassTargetFinder.with_a_char(self.target_name) do |model|
          LuckRecord.create(date: date, character: model, reason: self.reason, from: enactor.name)
          client.emit_success t('luckgive.given_luck', :name => model.name)
          message = t('luckgive.received_luck', :from => enactor.name)
          Login.emit_if_logged_in model, message
          FS3Skills.modify_luck(model, 1)
          FS3Skills.modify_luck(enactor, -1)
        end
      end

    end
  end
end
