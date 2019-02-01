module AresMUSH
  module Custom
    class CompGiveCmd
      #comp <name>=<text>
      include CommandHandler
      attr_accessor

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.target = Character.named(args.arg1)
       self.comp = args.arg2
      end

      def handle
        Comps.create(date: Time.now, character: enactor, comp: self.comp)
        client.emit_success t('custom.left_comp', :name => self.target.name)
        Cookies.give_cookie(self.target, enactor.client, enactor)
      end

    end
  end
end
