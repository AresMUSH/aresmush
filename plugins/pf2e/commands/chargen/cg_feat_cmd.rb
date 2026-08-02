module AresMUSH
  module Pf2e
    class CgFeatCmd
      include CommandHandler

      attr_accessor :arg

      def parse_args
        self.arg = cmd.args ? cmd.args.strip.downcase : nil
      end

      def handle
        # No args or "list" → eligible feats
        if self.arg.blank? || self.arg == "list"
          result = Pf2e.cg_ensure_sheet(enactor)
          if !result[:ok]
            client.emit_failure t(result[:error])
            return
          end
          locked = Pf2e.cg_require_identity_locked(result[:sheet])
          if locked
            client.emit_failure t(locked[:error])
            return
          end

          rows = Pf2e.feat_eligible_list(enactor)
          if rows.empty?
            client.emit t('pf2e.cg_feat_none_eligible')
            return
          end

          lines = [t('pf2e.cg_feat_eligible_header')]
          rows.each do |r|
            bits = []
            bits << "L#{r[:level]}" if r[:level].to_i > 0
            bits << r[:category] unless r[:category].to_s.empty?
            note = bits.empty? ? "" : " (#{bits.join(', ')})"
            lines << "  #{r[:slug]} — #{r[:name]}#{note}"
          end
          client.emit lines.join("\n")
          return
        end

        # Optional filter: cg/feat skill | general | class | ancestry
        if %w[skill general class ancestry dedication archetype].include?(self.arg)
          result = Pf2e.cg_ensure_sheet(enactor)
          if !result[:ok]
            client.emit_failure t(result[:error])
            return
          end
          locked = Pf2e.cg_require_identity_locked(result[:sheet])
          if locked
            client.emit_failure t(locked[:error])
            return
          end

          rows = Pf2e.feat_eligible_list(enactor, category: self.arg)
          if rows.empty?
            client.emit t('pf2e.cg_feat_none_eligible')
            return
          end

          lines = [t('pf2e.cg_feat_eligible_header_cat', :category => self.arg)]
          rows.each do |r|
            lines << "  #{r[:slug]} — #{r[:name]} (L#{r[:level]})"
          end
          client.emit lines.join("\n")
          return
        end

        result = Pf2e.cg_take_feat(enactor, self.arg)
        if !result[:ok]
          if result[:failures]
            client.emit_failure t('pf2e.cg_feat_prereq', :reasons => result[:failures].join("; "))
          else
            client.emit_failure t(result[:error])
          end
          return
        end

        client.emit_success t('pf2e.cg_feat_set', :name => result[:name])
      end
    end
  end
end
