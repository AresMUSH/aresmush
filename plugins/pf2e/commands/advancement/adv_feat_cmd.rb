module AresMUSH
  module Pf2e
    class AdvFeatCmd
      include CommandHandler

      attr_accessor :slug, :slot_type

      def parse_args
        raw = cmd.args ? cmd.args.strip.downcase : ""
        parts = raw.split(/\s+/)
        self.slug = parts[0]
        self.slot_type = parts[1]
      end

      def handle
        if self.slug.blank? || self.slug == "list"
          status = Pf2e.adv_status(enactor)
          unless status[:ok]
            client.emit_failure t(status[:error])
            return
          end
          unless status[:advancing]
            client.emit_failure t('pf2e.adv_not_advancing')
            return
          end

          slots = status[:feat_slots]
          lines = [t('pf2e.cg_feat_slots_header')]
          Pf2e::FEAT_SLOT_TYPES.each do |typ|
            lines << "  #{typ}: #{slots[:used][typ]}/#{slots[:total][typ]} used (#{slots[:remaining][typ]} left)"
          end
          rows = Pf2e.feat_eligible_list(enactor)
          if rows.empty?
            lines << t('pf2e.cg_feat_none_eligible')
          else
            lines << t('pf2e.cg_feat_eligible_header')
            rows.first(25).each do |r|
              lines << "  #{r[:slug]} — #{r[:name]} (L#{r[:level]}; #{Array(r[:open_slots]).join('|')})"
            end
          end
          client.emit lines.join("\n")
          return
        end

        result = Pf2e.adv_take_feat(enactor, self.slug, slot_type: self.slot_type)
        unless result[:ok]
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

        client.emit_success t('pf2e.adv_feat_ok',
                              :name => result[:name],
                              :slot => result[:slot])
      end
    end
  end
end
