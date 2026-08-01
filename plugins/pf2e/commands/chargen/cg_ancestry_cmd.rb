module AresMUSH
  module Pf2e
    class CgAncestryCmd
      include CommandHandler

      attr_accessor :slug

      def parse_args
        self.slug = cmd.args ? cmd.args.strip.downcase : nil
      end

      def check_args
        return t('pf2e.cg_ancestry_usage') if self.slug.blank?
        nil
      end

      def handle
        result = Pf2e.cg_set_ancestry(enactor, self.slug)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        name = (result[:entry] && result[:entry]["name"]) || self.slug
        client.emit_success t('pf2e.cg_ancestry_set', :name => name)
      end
    end
  end
end
