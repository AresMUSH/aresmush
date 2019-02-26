module AresMUSH
  module Custom
    class CompGiveCmd
      #comp <name>=<text>
      include CommandHandler
      attr_accessor :target, :comp

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.target = Character.named(args.arg1)
       self.comp = args.arg2
      end

      def check_errors
        return t('custom.invalid_name') if !self.target
        return nil
      end

      def handle
        date = Time.now.strftime("%Y-%m-%d")

        Comps.create(date: date, character: self.target, comp_msg: self.comp, from: enactor.name)

        client.emit_success t('custom.left_comp', :name => self.target.name)
        message = t('custom.has_left_comp', :from => enactor.name)
        Login.emit_if_logged_in self.target, message

        Cookies.give_cookie(self.target, enactor)
      end

    end
  end
end
