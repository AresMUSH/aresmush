module AresMUSH
  module Pf2e
    class CgBoostCmd
      include CommandHandler

      attr_accessor :source, :abilities

      def parse_args
        parts = cmd.args.to_s.split
        self.source = parts[0] ? parts[0].strip.downcase : nil
        self.abilities = parts[1..-1] || []
      end

      def check_args
        return t('pf2e.cg_boost_usage') if self.source.blank? || self.abilities.empty?
        nil
      end

      def handle
        result = Pf2e.cg_set_boosts(enactor, self.source, self.abilities)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        list = Array(result[:boosts]).map { |a| a.upcase }.join(", ")
        client.emit_success t('pf2e.cg_boost_set', :source => self.source, :list => list)
      end
    end
  end
end
