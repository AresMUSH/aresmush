module AresMUSH
  module Pf2e
    class SpellsCastCmd
      include CommandHandler

      attr_accessor :spell

      def parse_args
        self.spell = cmd.args.to_s.strip.downcase
      end

      def check_args
        return t('pf2e.innate_cast_usage') if self.spell.blank?
        nil
      end

      def handle
        # Prefer innate grant if present; class slot casting is still table-narrated for now.
        if Pf2e.find_innate_spell(enactor, self.spell)
          result = Pf2e.innate_cast(enactor, self.spell)
          unless result[:ok]
            case result[:error]
            when "pf2e.innate_exhausted"
              client.emit_failure t('pf2e.innate_exhausted', :spell => result[:spell], :used => result[:used], :max => result[:max])
            when "pf2e.innate_not_found"
              client.emit_failure t('pf2e.innate_not_found', :spell => result[:spell])
            else
              client.emit_failure t(result[:error] || 'pf2e.no_sheet')
            end
            return
          end

          if result[:frequency].to_s == "at_will"
            client.emit_success t('pf2e.innate_cast_atwill',
                                 :spell => result[:spell],
                                 :dc => result[:dc],
                                 :attack => result[:attack])
          else
            client.emit_success t('pf2e.innate_cast_ok',
                                 :spell => result[:spell],
                                 :used => result[:used],
                                 :max => result[:max],
                                 :dc => result[:dc],
                                 :attack => result[:attack])
          end
          return
        end

        client.emit_failure t('pf2e.innate_not_found', :spell => self.spell)
      end
    end
  end
end
