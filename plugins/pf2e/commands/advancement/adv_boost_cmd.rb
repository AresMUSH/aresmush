module AresMUSH
  module Pf2e
    class AdvBoostCmd
      include CommandHandler

      attr_accessor :abilities

      def parse_args
        raw = cmd.args ? cmd.args.strip.downcase : ""
        self.abilities = raw.split(/\s+/).reject(&:empty?)
      end

      def handle
        if self.abilities.empty?
          client.emit_failure t('pf2e.adv_boost_usage')
          return
        end

        result = Pf2e.adv_ability_boosts(enactor, self.abilities)
        unless result[:ok]
          if result[:error] == "pf2e.adv_boost_count"
            client.emit_failure t('pf2e.adv_boost_count', :needed => result[:needed])
          else
            client.emit_failure t(result[:error])
          end
          return
        end

        client.emit_success t('pf2e.adv_boost_ok',
                              :list => result[:boosts].map(&:upcase).join(", "),
                              :source => result[:source])
      end
    end
  end
end
