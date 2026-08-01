module AresMUSH
  module Pf2e
    class CgClassCmd
      include CommandHandler

      attr_accessor :slug, :key_ability

      def parse_args
        parts = cmd.args.to_s.split
        self.slug = parts[0] ? parts[0].strip.downcase : nil
        self.key_ability = parts[1] ? parts[1].strip.downcase : nil
      end

      def check_args
        return t('pf2e.cg_class_usage') if self.slug.blank?
        nil
      end

      def handle
        result = Pf2e.cg_set_class(enactor, self.slug, key_ability: self.key_ability)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        name = (result[:entry] && result[:entry]["name"]) || self.slug
        ka = (result[:sheet].charclass || {})["key_ability"]
        client.emit_success t('pf2e.cg_class_set', :name => name, :ability => ka || "—")
      end
    end
  end
end
