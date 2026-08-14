module AresMUSH
  module Pf2e
    class SpellsLearnCmd
      include CommandHandler

      attr_accessor :source, :spell, :rank

      def parse_args
        # spells/learn <source>=<spell> [rank]
        # spells/learn <spell> [rank]  (single source)
        raw = cmd.args.to_s.strip
        self.source = nil
        self.spell = nil
        self.rank = nil
        return if raw.blank?

        if raw =~ /\A([^=]+)=(.+)\z/
          self.source = $1.strip
          rest = $2.strip
        else
          rest = raw
        end

        bits = rest.split(/\s+/)
        self.spell = bits[0].to_s.strip.downcase
        self.rank = bits[1].to_i if bits[1] && bits[1] =~ /\A\d+\z/
      end

      def check_args
        return t('pf2e.magic_learn_usage') if self.spell.blank?
        nil
      end

      def handle
        result = Pf2e.magic_learn(enactor, self.source, self.spell, rank: self.rank)
        unless result[:ok]
          case result[:error]
          when "pf2e.magic_source_required"
            client.emit_failure t('pf2e.magic_source_required', :sources => Array(result[:sources]).join(', '))
          when "pf2e.magic_unknown_spell"
            client.emit_failure t('pf2e.magic_unknown_spell', :spells => Array(result[:spells]).join(', '))
          else
            client.emit_failure t(result[:error] || 'pf2e.no_sheet')
          end
          return
        end
        client.emit_success t('pf2e.magic_learn_ok', :spell => result[:spell], :source => result[:source], :rank => result[:rank])
      end
    end
  end
end
