module AresMUSH
  module Magic
    class SpellSearchCmd
    # spell/search <spell name>
      include CommandHandler

      attr_accessor :spell

      def parse_args
        self.spell = titlecase_arg(cmd.args)
      end

      def check_errors
        return "What spell do you want to search?" if !self.spell
        return t('magic.not_spell') if !Magic.is_spell?(self.spell)
        return nil
      end

      def handle
        client.emit "=============== CHARACTERS WHO KNOW #{self.spell.upcase} ==============="
        chars = Chargen.approved_chars.select { |c| Magic.knows_spell?(c, self.spell) }
        chars.each do |c|
          client.emit c.name
        end
      end

    end
  end
end
