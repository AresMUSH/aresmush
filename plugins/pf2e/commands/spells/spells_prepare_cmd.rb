module AresMUSH
  module Pf2e
    class SpellsPrepareCmd
      include CommandHandler

      attr_accessor :source, :rank, :spells

      def parse_args
        # spells/prepare <source>=<rank>/<spell> [spell...]
        # spells/prepare <rank>/<spell> ...  (single source only)
        raw = cmd.args.to_s.strip
        self.source = nil
        self.rank = nil
        self.spells = []
        return if raw.blank?

        if raw =~ /\A([^=]+)=(.+)\z/
          self.source = $1.strip
          rest = $2.strip
        else
          rest = raw
        end

        if rest =~ /\A([^\/]+)\/(.+)\z/
          self.rank = $1.strip.downcase
          self.spells = $2.split(/[\s,]+/).map { |s| s.strip.downcase }.reject(&:empty?)
        end
      end

      def check_args
        return t('pf2e.magic_prepare_usage') if self.rank.blank? || self.spells.empty?
        nil
      end

      def handle
        ranks = { self.rank => self.spells }
        result = Pf2e.magic_prepare(enactor, self.source, ranks)
        unless result[:ok]
          case result[:error]
          when "pf2e.magic_source_required"
            client.emit_failure t('pf2e.magic_source_required', :sources => Array(result[:sources]).join(', '))
          when "pf2e.magic_unknown_spell"
            client.emit_failure t('pf2e.magic_unknown_spell', :spells => Array(result[:spells]).join(', '))
          when "pf2e.magic_not_prepared"
            client.emit_failure t('pf2e.magic_not_prepared', :source => result[:source])
          else
            client.emit_failure t(result[:error] || 'pf2e.no_sheet')
          end
          return
        end
        client.emit_success t('pf2e.magic_prepare_ok', :source => result[:source], :rank => self.rank, :list => self.spells.join(', '))
      end
    end
  end
end
