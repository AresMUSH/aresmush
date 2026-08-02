module AresMUSH
  module Pf2e
    class CgFeatRemoveCmd
      include CommandHandler

      attr_accessor :slug

      def parse_args
        self.slug = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        if self.slug.blank?
          client.emit_failure t('pf2e.cg_feat_remove_usage')
          return
        end

        result = Pf2e.cg_remove_feat(enactor, self.slug)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        client.emit_success t('pf2e.cg_feat_removed', :name => result[:name])
      end
    end
  end
end
