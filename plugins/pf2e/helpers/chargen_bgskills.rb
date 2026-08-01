module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Background skill_choices
    # list  — pick from closed options (Guard, Noble, Martial Disciple)
    # lore  — open specialty → trains <specialty>_lore (Nomad)
    # Optional feats: map option slug → feat slug granted with that pick
    # -------------------------------------------------

    def self.cg_background_skill_choice_entries(sheet)
      bg = cg_background_entry(sheet.background)
      return [] unless bg.is_a?(Hash)
      Array(bg["skill_choices"])
    end

    def self.cg_background_skill_slots(sheet)
      slots = []
      cg_background_skill_choice_entries(sheet).each_with_index do |entry, idx|
        next unless entry.is_a?(Hash)
        pick = [entry["pick"].to_i, 1].max
        pick.times { slots << entry.merge("_choice_index" => idx) }
      end
      slots
    end

    def self.cg_background_skill_picks(sheet)
      Array(sheet.background_skill_picks).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
    end

    def self.cg_background_skill_slots_remaining(sheet)
      [cg_background_skill_slots(sheet).size - cg_background_skill_picks(sheet).size, 0].max
    end

    def self.cg_background_skill_status(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      if sheet.background.blank?
        return { ok: false, error: "pf2e.cg_need_background", sheet: sheet }
      end

      slots = cg_background_skill_slots(sheet)
      picks = cg_background_skill_picks(sheet)
      pending = []
      slots.each_with_index do |slot, i|
        next if i < picks.size
        pending << summarize_bg_skill_slot(slot)
      end

      {
        ok: true,
        error: nil,
        sheet: sheet,
        total: slots.size,
        resolved: picks,
        remaining: pending.size,
        pending: pending
      }
    end

    def self.summarize_bg_skill_slot(slot)
      type = slot["type"].to_s
      if type == "lore"
        cat = slot["category"].to_s
        cat.empty? ? "open lore" : "open lore (#{cat})"
      else
        opts = Array(slot["options"]).map(&:to_s)
        feat_map = slot["feats"] || {}
        if feat_map.is_a?(Hash) && !feat_map.empty?
          bits = opts.map do |o|
            f = feat_map[o] || feat_map[o.to_sym]
            f ? "#{o}→#{f}" : o
          end
          "choose: #{bits.join(", ")}"
        else
          "choose: #{opts.join(", ")}"
        end
      end
    end

    # Resolve the next pending skill_choice slot.
    # arg: option slug for type:list, or specialty / specialty_lore for type:lore
    # If the slot has feats: { option => feat_slug }, that feat is added.
    def self.cg_resolve_background_skill(char, arg)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      if sheet.background.blank?
        return { ok: false, error: "pf2e.cg_need_background", sheet: sheet }
      end

      raw = arg.to_s.strip.downcase
      return { ok: false, error: "pf2e.cg_bgskill_usage", sheet: sheet } if raw.empty?

      slots = cg_background_skill_slots(sheet)
      picks = cg_background_skill_picks(sheet)
      if picks.size >= slots.size
        return { ok: false, error: "pf2e.cg_bgskill_none_pending", sheet: sheet }
      end

      slot = slots[picks.size]
      type = slot["type"].to_s

      skill_key =
        if type == "lore"
          specialty = raw.sub(/_lore\z/, "")
          return { ok: false, error: "pf2e.cg_bgskill_bad_lore", sheet: sheet } if specialty.empty?
          "#{specialty}_lore"
        else
          options = Array(slot["options"]).map { |o| o.to_s.strip.downcase }
          unless options.include?(raw)
            return { ok: false, error: "pf2e.cg_bgskill_not_in_options", sheet: sheet }
          end
          raw
        end

      if skill_rank(sheet, skill_key) != "U"
        return { ok: false, error: "pf2e.cg_skill_already_trained", sheet: sheet }
      end

      set_skill_rank(sheet, skill_key, "T")
      new_picks = picks + [skill_key]
      sheet.update(background_skill_picks: new_picks)

      granted_feat = nil
      feat_map = slot["feats"]
      if feat_map.is_a?(Hash)
        # Match on the option key the player chose (list) or full skill key
        feat_slug = feat_map[skill_key] || feat_map[skill_key.to_sym] ||
                    feat_map[raw] || feat_map[raw.to_sym]
        feat_slug = feat_slug.to_s.strip.downcase if feat_slug
        if feat_slug && !feat_slug.empty?
          feats = Array(sheet.feats).map { |f| f.to_s }
          unless feats.include?(feat_slug)
            feats << feat_slug
            sheet.update(feats: feats)
          end
          granted_feat = feat_slug
        end
      end

      {
        ok: true,
        error: nil,
        sheet: sheet,
        skill: skill_key,
        feat: granted_feat,
        remaining: cg_background_skill_slots_remaining(sheet)
      }
    end

  end
end
