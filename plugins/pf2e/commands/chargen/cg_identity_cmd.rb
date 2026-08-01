module AresMUSH
  module Pf2e
    class CgIdentityCmd
      include CommandHandler

      def handle
        result = Pf2e.cg_identity_summary(enactor)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        lock = result[:locked] ? "LOCKED" : "unlocked (Stage A)"
        lines = []
        lines << t('pf2e.cg_identity_header', :lock => lock)
        lines << t('pf2e.cg_identity_line',
                   :label => "Ancestry",
                   :value => result[:ancestry_name] || result[:ancestry] || "—")
        lines << t('pf2e.cg_identity_line',
                   :label => "Heritage",
                   :value => result[:heritage_name] || result[:heritage] || "—")
        lines << t('pf2e.cg_identity_line',
                   :label => "Background",
                   :value => result[:background_name] || result[:background] || "—")
        class_val = result[:charclass_name] || result[:charclass] || "—"
        if result[:key_ability]
          class_val = "#{class_val} (key: #{result[:key_ability]})"
        end
        lines << t('pf2e.cg_identity_line', :label => "Class", :value => class_val)

        lines << t('pf2e.cg_identity_grants_header')
        lines << t('pf2e.cg_identity_line', :label => "Speed", :value => result[:speed] || "—")
        lines << t('pf2e.cg_identity_line',
                   :label => "HP (anc+class)",
                   :value => "#{result[:hp_ancestry] || "?"} + #{result[:hp_class] || "?"}/level")

        fixed = result[:fixed_skills].empty? ? "(none)" : result[:fixed_skills].join(", ")
        lines << t('pf2e.cg_identity_line', :label => "BG skills", :value => fixed)

        if result[:skill_choices].any?
          lines << t('pf2e.cg_identity_line',
                     :label => "BG choices",
                     :value => "#{result[:skill_choices].size} pending after commit")
        end

        feat = result[:background_feat].to_s
        feat = "(none)" if feat.empty? || feat == "null"
        lines << t('pf2e.cg_identity_line', :label => "BG feat", :value => feat)

        add = result[:class_additional_skills].empty? ? "(none)" : result[:class_additional_skills].join(", ")
        lines << t('pf2e.cg_identity_line', :label => "Class skills", :value => add)
        lines << t('pf2e.cg_identity_line',
                   :label => "Class skill picks",
                   :value => "#{result[:class_trained_count]} + Int")

        b = result[:boosts] || {}
        lines << t('pf2e.cg_identity_line',
                   :label => "Boosts",
                   :value => "anc free #{b[:ancestry_free] || 0}, bg free #{b[:background_free] || 0}, key #{b[:class_key] || "—"}")

        unless result[:complete]
          lines << t('pf2e.cg_identity_incomplete')
        end
        if !result[:locked] && result[:complete]
          lines << t('pf2e.cg_identity_ready_commit')
        end

        client.emit lines.join("\n")
      end
    end
  end
end
