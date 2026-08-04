module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Advancement packages (Remaster)
    #
    # Class data: entry["advancement"][level] = {
    #   features: [], class_feat:, skill_feat:, general_feat:, ancestry_feat:,
    #   skill_increase:, ability_boost:, proficiency: {}, choice: {},
    #   spellcasting: {}, notes: ""
    # }
    #
    # Universal (not repeated per class):
    #   skill_increase at every level 2..20
    #   ability_boost ×4 at 5, 10, 15, 20
    #   ancestry/general feat slots via UNIVERSAL_FEAT_SLOT_LEVELS
    # -------------------------------------------------

    UNIVERSAL_SKILL_INCREASE_FROM = 2
    UNIVERSAL_ABILITY_BOOST_LEVELS = {
      5 => 4, 10 => 4, 15 => 4, 20 => 4
    }.freeze

    # Rank gates for skill increases (Remaster).
    SKILL_RANK_MIN_LEVEL = {
      "E" => 3,
      "M" => 7,
      "L" => 15
    }.freeze

    def self.advancement_package(class_entry, level)
      return {} unless class_entry.is_a?(Hash)
      adv = class_entry["advancement"]
      if adv.is_a?(Hash)
        pkg = adv[level] || adv[level.to_s] || adv[level.to_i]
        return pkg.is_a?(Hash) ? pkg : {}
      end

      # Synthesize a minimal package from legacy features_by_level
      legacy = (class_entry["features_by_level"] || {})[level] ||
               (class_entry["features_by_level"] || {})[level.to_s]
      return {} unless legacy

      pkg = { "features" => [] }
      Array(legacy).each do |token|
        slot = slot_type_for_marker(token)
        if slot
          key = "#{slot}_feat"
          pkg[key] = pkg[key].to_i + 1
        else
          pkg["features"] << token.to_s.strip.downcase
        end
      end
      pkg
    end

    def self.universal_grants_at(level)
      lvl = level.to_i
      {
        "skill_increase" => (lvl >= UNIVERSAL_SKILL_INCREASE_FROM ? 1 : 0),
        "ability_boost" => UNIVERSAL_ABILITY_BOOST_LEVELS[lvl].to_i
      }
    end

    # Full package for a character level: class + universal.
    def self.level_package(char_or_sheet, level)
      sheet = sheet_for(char_or_sheet)
      entry = class_entry_for_sheet(sheet)
      class_pkg = advancement_package(entry, level)
      uni = universal_grants_at(level)

      {
        "level" => level.to_i,
        "features" => Array(class_pkg["features"]).map { |s| s.to_s.strip.downcase }.reject(&:empty?),
        "class_feat" => class_pkg["class_feat"].to_i,
        "skill_feat" => class_pkg["skill_feat"].to_i,
        "general_feat" => class_pkg["general_feat"].to_i,
        "ancestry_feat" => class_pkg["ancestry_feat"].to_i,
        "skill_increase" => class_pkg["skill_increase"].to_i + uni["skill_increase"],
        "ability_boost" => class_pkg["ability_boost"].to_i + uni["ability_boost"],
        "proficiency" => class_pkg["proficiency"].is_a?(Hash) ? class_pkg["proficiency"] : {},
        "choice" => class_pkg["choice"],
        "spellcasting" => class_pkg["spellcasting"].is_a?(Hash) ? class_pkg["spellcasting"] : {},
        "notes" => class_pkg["notes"].to_s
      }
    end

    def self.empty_pending
      {
        "skill_increase" => 0,
        "ability_boost" => 0,
        "class_feat" => 0,
        "skill_feat" => 0,
        "general_feat" => 0,
        "ancestry_feat" => 0
      }
    end

    def self.sheet_pending(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return empty_pending unless sheet
      raw = sheet.respond_to?(:pending_advancement) ? sheet.pending_advancement : nil
      base = empty_pending
      return base unless raw.is_a?(Hash)
      base.keys.each { |k| base[k] = raw[k].to_i }
      base
    end

    def self.set_pending(sheet, hash)
      merged = empty_pending
      hash.each { |k, v| merged[k.to_s] = v.to_i if merged.key?(k.to_s) }
      sheet.update(pending_advancement: merged) if sheet.respond_to?(:pending_advancement)
      merged
    end

    def self.add_pending!(sheet, deltas)
      cur = sheet_pending(sheet)
      deltas.each { |k, v| cur[k.to_s] = cur[k.to_s].to_i + v.to_i if cur.key?(k.to_s) }
      set_pending(sheet, cur)
    end

    # Whether a skill rank step is legal at character level.
    def self.skill_increase_rank_ok?(char_level, new_rank)
      rank = new_rank.to_s.strip.upcase
      return true if rank == "T"
      min = SKILL_RANK_MIN_LEVEL[rank]
      return false unless min
      char_level.to_i >= min
    end

    def self.next_skill_rank(current)
      case current.to_s.strip.upcase
      when "U", "" then "T"
      when "T" then "E"
      when "E" then "M"
      when "M" then "L"
      else nil
      end
    end

  end
end
