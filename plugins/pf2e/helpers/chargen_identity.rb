module AresMUSH
  module Pf2e

    def self.cg_identity_locked?(sheet)
      return false unless sheet
      val = sheet.identity_locked
      val == true || val.to_s == "true" || val.to_s == "1"
    end

    def self.cg_char_approved?(char)
      return false unless char
      if char.respond_to?(:is_approved?)
        return true if char.is_approved?
      end
      if defined?(Chargen)
        if Chargen.respond_to?(:is_approved?)
          return true if Chargen.is_approved?(char)
        end
        if Chargen.respond_to?(:check_chargen_locked)
          msg = Chargen.check_chargen_locked(char)
          return true if msg
        end
      end
      false
    end

    def self.cg_require_not_approved(char, sheet = nil)
      if cg_char_approved?(char)
        return { ok: false, error: "pf2e.cg_approved_locked", sheet: sheet }
      end
      nil
    end

    def self.cg_require_identity_unlocked(sheet)
      return { ok: false, error: "pf2e.cg_identity_locked", sheet: sheet } if cg_identity_locked?(sheet)
      nil
    end

    def self.cg_require_identity_locked(sheet)
      return { ok: false, error: "pf2e.cg_identity_not_locked", sheet: sheet } unless cg_identity_locked?(sheet)
      nil
    end

    def self.cg_reset_sheet(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      blocked = cg_require_not_approved(char, result[:sheet])
      return blocked if blocked

      sheet = result[:sheet]
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
          "str" => [10, 10],
          "dex" => [10, 10],
          "con" => [10, 10],
          "int" => [10, 10],
          "wis" => [10, 10],
          "cha" => [10, 10]
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

      { ok: true, error: nil, sheet: sheet }
    end

    # PF2e Remaster baseline is 15 gp. Destination defaults to Society account
    # (Tapestry: Hall ledger; withdraw to shop). Override in pf2e.yml:
    #   starting_wealth: "15gp"
    #   starting_wealth_to: society | purse
    def self.cg_starting_wealth_purse
      raw = Global.read_config("pf2e", "starting_wealth")
      raw = "15gp" if raw.nil? || raw.to_s.strip.empty?
      parsed = parse_coin_string(raw.to_s)
      return parsed if parsed
      # bare number = gold pieces
      if raw.to_s.strip =~ /\A\d+\z/
        return normalize_purse("gp" => raw.to_i)
      end
      normalize_purse("gp" => 15)
    end

    def self.cg_grant_starting_wealth(sheet)
      return nil unless sheet
      amount = cg_starting_wealth_purse
      dest = Global.read_config("pf2e", "starting_wealth_to").to_s.strip.downcase
      dest = "society" if dest.empty?

      # Clear both so a re-commit after cg/reset is deterministic.
      set_money(sheet, empty_purse)
      set_society_account(sheet, empty_purse)

      if dest == "purse"
        set_money(sheet, amount)
      else
        set_society_account(sheet, amount)
      end

      {
        amount: amount,
        destination: dest == "purse" ? "purse" : "society",
        display: format_money(amount)
      }
    end

    def self.cg_identity_summary(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      anc = cg_ancestry_entry(sheet.ancestry)
      her = cg_heritage_entry(sheet.heritage)
      bg  = cg_background_entry(sheet.background)
      cc  = sheet.charclass || {}
      class_entry = cg_class_entry(cc["slug"] || cc[:slug])

      fixed_skills = []
      skill_choices = []
      feat = nil
      if bg.is_a?(Hash)
        fixed_skills = Array(bg["skills"]).map(&:to_s)
        skill_choices = Array(bg["skill_choices"])
        feat = bg["feat"]
      end

      class_additional = []
      trained_count = 0
      class_langs = []
      if class_entry.is_a?(Hash)
        class_additional = Array((class_entry["skills"] || {})["additional"]).map(&:to_s)
        trained_count = ((class_entry["skills"] || {})["trained_count"] || 0).to_i
        class_langs = Array((class_entry["languages"] || {})["starting"]).map(&:to_s)
      end

      anc_langs = []
      if anc.is_a?(Hash)
        anc_langs = Array((anc["languages"] || {})["starting"]).map(&:to_s)
      end

      boosts_preview = {}
      if anc.is_a?(Hash)
        boosts_preview[:ancestry_fixed] = Array((anc["boosts"] || {})["fixed"])
        boosts_preview[:ancestry_free] = (anc["boosts"] || {})["free"].to_i
        boosts_preview[:ancestry_flaws] = Array((anc["flaws"] || {})["fixed"])
      end
      if bg.is_a?(Hash)
        boosts_preview[:background_free] = (bg["boosts"] || {})["free"].to_i
        boosts_preview[:background_options] = (bg["boosts"] || {})["options"]
      end
      if her.is_a?(Hash)
        boosts_preview[:heritage_free] = ((her["boosts"] || {})["free"] || 0).to_i
      end
      boosts_preview[:class_key] = cc["key_ability"] || cc[:key_ability]

      feature_preview = []
      if anc.is_a?(Hash)
        feature_preview.concat(Array(anc["features"]).map(&:to_s))
      end
      if her.is_a?(Hash)
        feature_preview.concat(Array(her["features"]).map(&:to_s))
      end
      if class_entry.is_a?(Hash)
        level = [sheet.level.to_i, 1].max
        (class_entry["features_by_level"] || {}).each do |lvl_key, features|
          next if lvl_key.to_i > level
          Array(features).each do |fk|
            k = fk.to_s
            next if feat_slot_marker?(k)
            feature_preview << k
          end
        end
      end

      {
        ok: true,
        error: nil,
        sheet: sheet,
        locked: cg_identity_locked?(sheet),
        ancestry: sheet.ancestry,
        ancestry_name: anc.is_a?(Hash) ? anc["name"] : nil,
        heritage: sheet.heritage,
        heritage_name: her.is_a?(Hash) ? her["name"] : nil,
        background: sheet.background,
        background_name: bg.is_a?(Hash) ? bg["name"] : nil,
        charclass: cc["slug"] || cc[:slug],
        charclass_name: cc["name"] || (class_entry.is_a?(Hash) ? class_entry["name"] : nil),
        key_ability: cc["key_ability"] || cc[:key_ability],
        speed: anc.is_a?(Hash) ? anc["speed"] : sheet.speed,
        hp_ancestry: anc.is_a?(Hash) ? anc["hp"] : nil,
        hp_class: class_entry.is_a?(Hash) ? class_entry["hp"] : nil,
        fixed_skills: fixed_skills,
        skill_choices: skill_choices,
        background_feat: feat,
        class_additional_skills: class_additional,
        class_trained_count: trained_count,
        languages_ancestry: anc_langs,
        languages_class: class_langs,
        languages_society: cg_society_languages,
        boosts: boosts_preview,
        features_preview: feature_preview.uniq,
        archetypes: sheet_archetypes(sheet),
        complete: !sheet.ancestry.blank? && !sheet.heritage.blank? &&
                  !sheet.background.blank? && !(cc["slug"] || cc[:slug]).to_s.empty?
      }
    end

    def self.cg_commit_identity(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      blocked = cg_require_not_approved(char, sheet)
      return blocked if blocked

      if cg_identity_locked?(sheet)
        return { ok: false, error: "pf2e.cg_identity_locked", sheet: sheet }
      end

      if sheet.ancestry.blank?
        return { ok: false, error: "pf2e.cg_need_ancestry", sheet: sheet }
      end
      if sheet.heritage.blank?
        return { ok: false, error: "pf2e.cg_need_heritage", sheet: sheet }
      end
      if sheet.background.blank?
        return { ok: false, error: "pf2e.cg_need_background", sheet: sheet }
      end
      cc = sheet.charclass || {}
      if (cc["slug"] || cc[:slug]).to_s.empty?
        return { ok: false, error: "pf2e.cg_need_class", sheet: sheet }
      end

      sheet.update(
        ability_boosts: {},
        background_skill_picks: [],
        languages: [],
        skills: {},
        saves: {},
        feats: [],
        feat_slot_map: {},
        features: [],
        archetypes: [],
        abilities: {
          "str" => [10, 10], "dex" => [10, 10], "con" => [10, 10],
          "int" => [10, 10], "wis" => [10, 10], "cha" => [10, 10]
        }
      )

      anc = cg_ancestry_entry(sheet.ancestry)
      if anc.is_a?(Hash) && anc["speed"]
        sheet.update(speed: anc["speed"].to_i)
      end

      bg = cg_background_entry(sheet.background)
      if bg.is_a?(Hash)
        Array(bg["skills"]).each do |sk|
          sk_key = sk.to_s.strip.downcase
          next if sk_key.empty?
          set_skill_rank(sheet, sk_key, "T")
        end
        feat = bg["feat"].to_s.strip.downcase
        if !feat.empty? && feat != "null"
          sheet.update(feats: [feat])
        end
      end

      class_entry = cg_class_entry(cc["slug"] || cc[:slug])
      if class_entry.is_a?(Hash)
        if class_entry["perception"]
          set_save_rank(sheet, "perception", class_entry["perception"])
        end
        (class_entry["saves"] || {}).each do |save_name, rank|
          set_save_rank(sheet, save_name, rank)
        end
        Array(((class_entry["skills"] || {})["additional"]) || []).each do |sk|
          sk_key = sk.to_s.strip.downcase
          next if sk_key.empty?
          set_skill_rank(sheet, sk_key, "T") if skill_rank(sheet, sk_key) == "U"
        end
      end

      cg_apply_granted_languages(sheet)
      cg_apply_granted_features(sheet)

      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      wealth = cg_grant_starting_wealth(sheet)

      sheet.update(identity_locked: true)

      {
        ok: true,
        error: nil,
        sheet: sheet,
        features: sheet_features(sheet),
        starting_wealth: wealth
      }
    end

  end
end
