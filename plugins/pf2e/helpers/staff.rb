module AresMUSH
  module Pf2e

    def self.can_manage_pf2e?(actor)
      actor && actor.has_permission?("manage_pf2e")
    end

    def self.can_view_sheet?(actor)
      actor && actor.has_permission?("view_sheet")
    end

    def self.can_view_char_sheet?(viewer, target)
      return false unless viewer && target
      return true if viewer == target
      can_view_sheet?(viewer)
    end

    def self.staff_require_permission(actor)
      return { ok: false, error: "pf2e.staff_no_permission" } unless can_manage_pf2e?(actor)
      nil
    end

    def self.staff_find_char(name)
      return nil if name.nil? || name.to_s.strip.empty?
      Character.named(name.to_s.strip)
    end

    def self.staff_ensure_sheet(char_name)
      char = staff_find_char(char_name)
      return { ok: false, error: "pf2e.character_not_found", char: nil, sheet: nil } unless char

      sheet = find_or_create_sheet(char)
      return { ok: false, error: "pf2e.no_sheet", char: char, sheet: nil } unless sheet

      { ok: true, error: nil, char: char, sheet: sheet }
    end

    def self.staff_set(enactor, char_name, field_path)
      blocked = staff_require_permission(enactor)
      return blocked if blocked

      result = staff_ensure_sheet(char_name)
      return result unless result[:ok]

      sheet = result[:sheet]
      char = result[:char]
      parts = field_path.to_s.strip.split("/").map { |p| p.strip.downcase }.reject(&:empty?)
      return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts.empty?

      field = parts[0]

      case field
      when "level"
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[1].nil?
        level = parts[1].to_i
        return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet } if level < 1
        sheet.update(level: level)
        cg_apply_granted_features(sheet)
        cg_recalc_hp(sheet)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "level=#{level}" }

      when "skill"
        skill = parts[1]
        rank = (parts[2] || "T").upcase
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if skill.nil?
        set_skill_rank(sheet, skill, rank)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "skill #{skill}=#{rank}" }

      when "save"
        save = parts[1]
        rank = (parts[2] || "T").upcase
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if save.nil?
        return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet } unless save_key(save)
        set_save_rank(sheet, save, rank)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "save #{save}=#{rank}" }

      when "ability"
        abil = ability_key(parts[1])
        return { ok: false, error: "pf2e.cg_unknown_ability", char: char, sheet: sheet } unless abil
        if parts[2] == "base" || parts[2] == "current"
          which = parts[2].to_sym
          val = parts[3].to_i
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[3].nil?
          if which == :base
            set_ability(sheet, abil, base: val)
          else
            set_ability(sheet, abil, current: val)
          end
          cg_recalc_hp(sheet)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "ability #{abil} #{which}=#{val}" }
        else
          val = parts[2].to_i
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[2].nil?
          set_ability(sheet, abil, current: val)
          cg_recalc_hp(sheet)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "ability #{abil} current=#{val}" }
        end

      when "feat"
        action = parts[1]
        slug = parts[2]
        slot = parts[3]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil? || slug.nil?
        feats = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
        map = (sheet.feat_slot_map || {}).dup
        if action == "add"
          limit = dedication_limit_block(sheet, slug, staff: true)
          return limit.merge(char: char) if limit

          feats << slug unless feats.include?(slug)
          if slot && feat_slot_type?(slot)
            map[slug] = slot
          end
          sheet.update(feats: feats, feat_slot_map: map)
          arch = archetype_on_dedication_taken(sheet, slug)
          note = slot ? " (#{slot})" : " (no slot)"
          note += " [#{arch}]" if arch
          { ok: true, error: nil, char: char, sheet: sheet, summary: "feat +#{slug}#{note}" }
        elsif action == "remove"
          dep = archetype_can_remove_dedication?(sheet, slug)
          return dep.merge(char: char) if dep
          feats.delete(slug)
          map.delete(slug)
          sheet.update(feats: feats, feat_slot_map: map)
          archetype_on_dedication_removed(sheet, slug)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "feat -#{slug}" }
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

      when "feature"
        action = parts[1]
        slug = parts[2]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil? || slug.nil?
        list = sheet_features(sheet)
        if action == "add"
          list << slug unless list.include?(slug)
          sheet.update(features: list)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "feature +#{slug}" }
        elsif action == "remove"
          list.delete(slug)
          sheet.update(features: list)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "feature -#{slug}" }
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

      when "language", "lang"
        action = parts[1]
        slug = parts[2]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil? || slug.nil?
        known = cg_known_languages(sheet)
        if action == "add"
          unless language_entry(slug)
            return { ok: false, error: "pf2e.cg_unknown_language", char: char, sheet: sheet }
          end
          known << slug unless known.include?(slug)
          sheet.update(languages: known)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "language +#{slug}" }
        elsif action == "remove"
          known.delete(slug)
          sheet.update(languages: known)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "language -#{slug}" }
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

      when "hp"
        which = parts[1]
        val = parts[2].to_i
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if which.nil? || parts[2].nil?
        unless %w[current max temp].include?(which)
          return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet }
        end
        hp = (sheet.hp || {}).dup
        hp[which] = val
        sheet.update(hp: hp)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "hp #{which}=#{val}" }

      when "speed"
        val = parts[1].to_i
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[1].nil?
        sheet.update(speed: val)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "speed=#{val}" }

      when "hero", "hero_points"
        val = parts[1].to_i
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[1].nil?
        sheet.update(hero_points: val)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "hero_points=#{val}" }

      when "focus", "focus_points"
        val = parts[1].to_i
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[1].nil?
        sheet.update(focus_points: val)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "focus_points=#{val}" }

      when "ancestry"
        slug = parts[1]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if slug.nil?
        entry = cg_ancestry_entry(slug)
        return { ok: false, error: "pf2e.cg_unknown_ancestry", char: char, sheet: sheet } unless entry
        sheet.update(ancestry: slug)
        cg_apply_granted_features(sheet)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "ancestry=#{slug}" }

      when "heritage"
        slug = parts[1]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if slug.nil?
        entry = cg_heritage_entry(slug)
        return { ok: false, error: "pf2e.cg_unknown_heritage", char: char, sheet: sheet } unless entry
        sheet.update(heritage: slug)
        cg_apply_granted_features(sheet)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "heritage=#{slug}" }

      when "background"
        slug = parts[1]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if slug.nil?
        entry = cg_background_entry(slug)
        return { ok: false, error: "pf2e.cg_unknown_background", char: char, sheet: sheet } unless entry
        sheet.update(background: slug)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "background=#{slug}" }

      when "class"
        slug = parts[1]
        key_abil = parts[2]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if slug.nil?
        entry = cg_class_entry(slug)
        return { ok: false, error: "pf2e.cg_unknown_class", char: char, sheet: sheet } unless entry
        chosen = key_abil ? ability_key(key_abil) : nil
        options = Array((entry["key_ability"] || {})["options"]).map { |a| ability_key(a) || a.to_s }
        chosen ||= options.first if options.size == 1
        sheet.update(charclass: {
          "slug" => slug,
          "name" => entry["name"] || slug,
          "key_ability" => chosen
        })
        cg_apply_granted_features(sheet)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "class=#{slug} key=#{chosen}" }

      when "identity"
        action = parts[1]
        if action == "lock"
          sheet.update(identity_locked: true)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "identity locked" }
        elsif action == "unlock"
          sheet.update(identity_locked: false)
          { ok: true, error: nil, char: char, sheet: sheet, summary: "identity unlocked" }
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

      else
        { ok: false, error: "pf2e.staff_unknown_field", char: char, sheet: sheet }
      end
    end

    def self.staff_reset_sheet(enactor, char_name)
      blocked = staff_require_permission(enactor)
      return blocked if blocked

      result = staff_ensure_sheet(char_name)
      return result unless result[:ok]

      sheet = result[:sheet]
      char = result[:char]

      sheet.update(
        level: 1,
        ancestry: nil,
        heritage: nil,
        background: nil,
        charclass: {},
        identity_locked: false,
        ability_boosts: {},
        background_skill_picks: [],
        languages: [],
        abilities: {
          "str" => [10, 10], "dex" => [10, 10], "con" => [10, 10],
          "int" => [10, 10], "wis" => [10, 10], "cha" => [10, 10]
        },
        skills: {},
        saves: {},
        feats: [],
        feat_slot_map: {},
        features: [],
        archetypes: [],
        money: { "pp" => 0, "gp" => 0, "sp" => 0, "cp" => 0 },
        society_account: { "pp" => 0, "gp" => 0, "sp" => 0, "cp" => 0 },
        inventory: [],
        item_seq: 0,
        hp: { "current" => 0, "max" => 0, "temp" => 0 },
        focus_points: 0,
        hero_points: 1,
        speed: 25,
        conditions: {},
        magic: {}
      )

      { ok: true, error: nil, char: char, sheet: sheet }
    end

  end
end
