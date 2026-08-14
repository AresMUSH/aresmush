module AresMUSH
  module Pf2e
    class CgFeatCmd
      include CommandHandler

      attr_accessor :arg, :slot_type

      def parse_args
        raw = cmd.args ? cmd.args.strip.downcase : nil
        self.arg = nil
        self.slot_type = nil
        return if raw.blank?

        # cg/feat <slug> [slot]   e.g. cg/feat assurance skill
        parts = raw.split(/\s+/)
        self.arg = parts[0]
        self.slot_type = parts[1] if parts.size > 1
      end

      def handle
        # No args or "list" → slot budget + eligible feats
        if self.arg.blank? || self.arg == "list" || self.arg == "slots"
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

          status = Pf2e.feat_slots_status(enactor)
          lines = [t('pf2e.cg_feat_slots_header')]
          Pf2e::FEAT_SLOT_TYPES.each do |t|
            lines << "  #{t}: #{status[:used][t]}/#{status[:total][t]} used (#{status[:remaining][t]} left)"
          end

          if self.arg == "slots"
            client.emit lines.join("\n")
            return
          end

          rows = Pf2e.feat_eligible_list(enactor)
          if rows.empty?
            lines << t('pf2e.cg_feat_none_eligible')
          else
            lines << t('pf2e.cg_feat_eligible_header')
            rows.each do |r|
              bits = []
              bits << "L#{r[:level]}" if r[:level].to_i > 0
              bits << r[:category] unless r[:category].to_s.empty?
              bits << "slots: #{r[:open_slots].join('|')}" if r[:open_slots]
              note = bits.empty? ? "" : " (#{bits.join(', ')})"
              lines << "  #{r[:slug]} — #{r[:name]}#{note}"
            end
          end
          client.emit lines.join("\n")
          return
        end

        # Filter by slot type or legacy category name
        if Pf2e.feat_slot_type?(self.arg) || %w[ancestry dedication archetype].include?(self.arg)
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

          if Pf2e.feat_slot_type?(self.arg)
            rows = Pf2e.feat_eligible_list(enactor, slot: self.arg)
            header = t('pf2e.cg_feat_eligible_header_slot', :slot => self.arg)
          else
            rows = Pf2e.feat_eligible_list(enactor, category: self.arg)
            header = t('pf2e.cg_feat_eligible_header_cat', :category => self.arg)
          end

          if rows.empty?
            client.emit t('pf2e.cg_feat_none_eligible')
            return
          end

          lines = [header]
          rows.each do |r|
            lines << "  #{r[:slug]} — #{r[:name]} (L#{r[:level]}; open: #{Array(r[:open_slots]).join('|')})"
          end
          client.emit lines.join("\n")
          return
        end

        result = Pf2e.cg_take_feat(enactor, self.arg, slot_type: self.slot_type)
        if !result[:ok]
          if result[:failures]
            client.emit_failure t('pf2e.cg_feat_prereq', :reasons => result[:failures].join("; "))
          elsif result[:error] == "pf2e.cg_feat_slot_required"
            client.emit_failure t('pf2e.cg_feat_slot_required', :slots => Array(result[:open_slots]).join(", "))
          elsif result[:error] == "pf2e.cg_feat_slot_unavailable"
            client.emit_failure t('pf2e.cg_feat_slot_unavailable', :slots => Array(result[:open_slots]).join(", "))
          else
            client.emit_failure t(result[:error])
          end
          return
        end

        client.emit_success t('pf2e.cg_feat_set_slot',
                             :name => result[:name],
                             :slot => result[:slot])
      end
    end
  end
end
