module AresMUSH
  module Custom
    class SpellRequestCmd
    # spell/request <spell name>=<text>
      include CommandHandler

      attr_accessor :spellname, :spelldesc

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.spellname = trim_arg(args.arg1)
        self.spelldesc = trim_arg(args.arg2)
      end

      def handle
        client.emit_success t('custom.spell_requested')    
        Jobs.create_job("SPELL", spellname, spelldesc, enactor)
      end

    end
  end
end
