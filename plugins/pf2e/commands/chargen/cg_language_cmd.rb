module AresMUSH
  module Pf2e
    class CgLanguageCmd
      include CommandHandler

      attr_accessor :slug

      def parse_args
        self.slug = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        if self.slug.blank?
          result = Pf2e.cg_language_status(enactor)
          if !result[:ok]
            client.emit_failure t(result[:error])
            return
          end

          known = result[:known].empty? ? "(none)" : result[:known].join(", ")
          opts = result[:options].map { |r|
            r[:note].to_s.empty? ? r[:slug] : "#{r[:slug]} (#{r[:note]})"
          }
          opt_str = opts.empty? ? "(none)" : opts.join(", ")

          client.emit t('pf2e.cg_language_status',
                       :known => known,
                       :used => result[:used],
                       :total => result[:total],
                       :remaining => result[:remaining],
                       :options => opt_str)
          return
        end

        result = Pf2e.cg_pick_language(enactor, self.slug)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.cg_language_set',
                             :language => result[:language],
                             :remaining => result[:remaining])
      end
    end
  end
end
