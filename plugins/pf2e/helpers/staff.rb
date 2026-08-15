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
      raw_parts = field_path.to_s.strip.split("/").map { |p| p.strip }.reject(&:empty?)
      parts = raw_parts.map { |p| p.downcase }
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

      when "xp", "experience"
        action = parts[1]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil? || parts[2].nil?

        if action == "set"
          val = parts[2].to_i
          return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet } if val < 0
          before = sheet_xp(sheet)
          sheet.update(xp: val)
          threshold = xp_to_level
          note = (val >= threshold && !advancing?(sheet)) ? " [ready to adv/start]" : ""
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "xp #{before} -> #{val}/#{threshold}#{note}" }
        elsif %w[add grant give].include?(action)
          amount = parts[2].to_i
          r = grant_xp(sheet, amount, source: "staff", reason: "pf2e/set by #{enactor ? enactor.name : 'staff'}")
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          note = r[:can_level] ? " [ready to adv/start]" : ""
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "xp +#{r[:amount]} -> #{r[:after]}/#{r[:threshold]}#{note}" }
        elsif %w[remove take subtract].include?(action)
          amount = -parts[2].to_i
          r = grant_xp(sheet, amount, source: "staff", reason: "pf2e/set by #{enactor ? enactor.name : 'staff'}")
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "xp #{r[:amount]} -> #{r[:after]}/#{r[:threshold]}" }
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

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

      when "money", "coin", "coins"
        action = parts[1]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil?

        rest = parts[2..-1] || []
        dest = "society"
        if rest.first && %w[society account hall].include?(rest.first)
          dest = "society"
          rest = rest[1..-1] || []
        elsif rest.first && %w[purse person coin coins].include?(rest.first)
          dest = "purse"
          rest = rest[1..-1] || []
        end

        amount = parse_coin_string(rest.join(" "))
        if amount.nil?
          return { ok: false, error: "pf2e.money_bad_amount", char: char, sheet: sheet }
        end

        if action == "add" || action == "grant"
          if dest == "purse"
            r = adjust_money(sheet, amount)
            return r.merge(char: char, sheet: sheet) unless r[:ok]
            { ok: true, error: nil, char: char, sheet: sheet,
              summary: "purse +#{format_money(amount)} -> #{format_money(r[:money])}" }
          else
            r = adjust_society_account(sheet, amount)
            return r.merge(char: char, sheet: sheet) unless r[:ok]
            { ok: true, error: nil, char: char, sheet: sheet,
              summary: "society +#{format_money(amount)} -> #{format_money(r[:society_account])}" }
          end
        elsif action == "remove" || action == "take"
          neg = COIN_KEYS.each_with_object({}) { |k, h| h[k] = -amount[k] }
          if dest == "purse"
            r = adjust_money(sheet, neg)
            return r.merge(char: char, sheet: sheet) unless r[:ok]
            { ok: true, error: nil, char: char, sheet: sheet,
              summary: "purse -#{format_money(amount)} -> #{format_money(r[:money])}" }
          else
            r = adjust_society_account(sheet, neg)
            return r.merge(char: char, sheet: sheet) unless r[:ok]
            { ok: true, error: nil, char: char, sheet: sheet,
              summary: "society -#{format_money(amount)} -> #{format_money(r[:society_account])}" }
          end
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

      when "item", "gear", "inv"
        action = parts[1]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil?

        case action
        when "add", "grant"
          slug = parts[2]
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if slug.nil?
          parsed = parse_item_kv_tokens(parts[3..-1])
          qty = parsed[:meta]["qty"] || 1
          qty = parts[3].to_i if parts[3] && parts[3] =~ /^\d+$/

          r = inventory_add_from_catalog(sheet, slug, qty: qty, society: true)
          return r.merge(char: char, sheet: sheet) unless r[:ok]

          item = r[:item]
          if parsed[:runes].any?
            inventory_set_runes(sheet, item["id"], parsed[:runes])
            item = find_item(sheet, item["id"])
          end
          if parsed[:magic].any?
            inventory_set_magic(sheet, item["id"], parsed[:magic])
            item = find_item(sheet, item["id"])
          end
          if parsed[:meta]["notes"]
            inventory_set_notes(sheet, item["id"], parsed[:meta]["notes"])
            item = find_item(sheet, item["id"])
          end

          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "item +#{item_display_name(item)} (#{item['id']}) [Society]" }

        when "custom"
          kind = parts[2] || "custom"
          name_token = raw_parts[3]
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if name_token.nil?
          name = name_token.tr("_", " ")
          parsed = parse_item_kv_tokens(parts[4..-1])

          r = inventory_add_custom(sheet,
                                  kind: kind,
                                  name: name,
                                  bulk: parsed[:meta]["bulk"],
                                  slug: parsed[:meta]["slug"],
                                  runes: parsed[:runes],
                                  magic: parsed[:magic],
                                  notes: parsed[:meta]["notes"] || "Society issue",
                                  society: true)
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          item = r[:item]
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "custom +#{item_display_name(item)} (#{item['id']}) [Society]" }

        when "remove", "drop", "take"
          id = parts[2]
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if id.nil?
          qty = parts[3] && parts[3] =~ /^\d+$/ ? parts[3].to_i : nil
          r = inventory_remove(sheet, id, qty: qty)
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          item = r[:item]
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "item -#{item_display_name(item)} (#{item['id']})" }

        when "runes", "rune"
          id = parts[2]
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if id.nil?
          parsed = parse_item_kv_tokens(parts[3..-1])
          return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet } if parsed[:runes].empty?
          r = inventory_set_runes(sheet, id, parsed[:runes])
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          item = r[:item]
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "runes on #{item_display_name(item)} (#{item['id']}): #{format_runes_brief(item)}" }

        when "magic"
          id = parts[2]
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if id.nil?
          parsed = parse_item_kv_tokens(parts[3..-1])
          return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet } if parsed[:magic].empty?
          r = inventory_set_magic(sheet, id, parsed[:magic])
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          item = r[:item]
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "magic on #{item_display_name(item)} (#{item['id']})" }

        when "notes", "note"
          id = parts[2]
          return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if id.nil?
          note = raw_parts[3..-1].join(" ").tr("_", " ")
          r = inventory_set_notes(sheet, id, note)
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "notes on #{id}" }

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

      when "magic", "spell", "spells"
        # Spellcasting / innate seed & grant (see helpers/staff_magic.rb)
        staff_set_magic(enactor, char, sheet, parts, raw_parts)

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
        xp: 0,
        advancing: false,
        pending_advancement: {},
        advancement_picks: {},
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
