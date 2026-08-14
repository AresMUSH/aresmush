module AresMUSH
  module Pf2e
    class CgAncestryCmd
      include CommandHandler

      attr_accessor :slug

      def parse_args
        self.slug = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        if self.slug.blank?
          rows = Pf2e.cg_list_ancestries
          client.emit Pf2e.cg_format_option_list(t('pf2e.cg_list_ancestries'), rows)
          return
        end

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
