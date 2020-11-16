module AresMUSH
  module Magic
    class SpellSearchCmd
    # spell/search <spell name>
      include CommandHandler

      attr_accessor :spell

      def parse_args
        self.spell = titlecase_arg(cmd.args)
      end


      def handle
        client.emit "_________________#{self.spell.upcase}__________________"
        chars = Chargen.approved_chars.select { |c| Magic.knows_spell?(c, self.spell) }
        chars.each do |c|
          client.emit c.name
        end
      end

    end
  end
end
