module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Feat slot economy (PF2e Remaster)
    # Types: ancestry, general, class, skill
    # Universal cadence matches Player Core:
    #   ancestry feats — 1, 5, 9, 13, 17
    #   general feats  — 3, 7, 11, 15, 19
    # Class and skill slots come from class features_by_level
    # markers (class_feat / fighter_feat / skill_feat / …).
    # -------------------------------------------------

    FEAT_SLOT_TYPES = %w[ancestry general class skill].freeze

    # Legacy alias: older YAML used "combat" for ancestry-feat slots.
    FEAT_SLOT_ALIASES = {
      "combat" => "ancestry"
    }.freeze

    UNIVERSAL_FEAT_SLOT_LEVELS = {
      "ancestry" => [1, 5, 9, 13, 17].freeze,
      "general"  => [3, 7, 11, 15, 19].freeze
    }.freeze

    # Which feat categories may be paid for by each slot type.
    SLOT_ALLOWED_CATEGORIES = {
      "general"  => %w[general skill].freeze,
      "skill"    => %w[skill].freeze,
      "class"    => %w[class dedication archetype].freeze,
      "ancestry" => %w[ancestry].freeze
    }.freeze

    def self.normalize_feat_slot(name)
      key = name.to_s.strip.downcase
      FEAT_SLOT_ALIASES[key] || key
    end

    def self.feat_slot_type?(name)
      FEAT_SLOT_TYPES.include?(normalize_feat_slot(name))
    end

    def self.feat_category(entry_or_slug)
      entry = entry_or_slug.is_a?(Hash) ? entry_or_slug : feat_entry(entry_or_slug)
      return "" unless entry.is_a?(Hash)
      cat = entry["category"].to_s.strip.downcase
      # Legacy category "combat" → ancestry
      cat == "combat" ? "ancestry" : cat
    end

    def self.feat_category_allows_slot?(category, slot_type)
      cat = category.to_s.strip.downcase
      cat = "ancestry" if cat == "combat"
      slot = normalize_feat_slot(slot_type)
      allowed = SLOT_ALLOWED_CATEGORIES[slot]
      return false unless allowed
      allowed.include?(cat)
    end

    def self.feat_slot_types_for(entry_or_slug)
      entry = entry_or_slug.is_a?(Hash) ? entry_or_slug : feat_entry(entry_or_slug)
      return [] unless entry.is_a?(Hash)

      cat = feat_category(entry)

      raw = entry["slots"] || entry["slot_types"]
      candidates = if raw.is_a?(Array) && raw.any?
                     raw.map { |s| normalize_feat_slot(s) }.select { |s| FEAT_SLOT_TYPES.include?(s) }
                   else
                     case cat
                     when "skill" then %w[skill general]
                     when "general" then %w[general]
                     when "class", "dedication", "archetype" then %w[class]
                     when "ancestry" then %w[ancestry]
                     else
                       FEAT_SLOT_TYPES.dup
                     end
                   end

      candidates.uniq.select { |slot| feat_category_allows_slot?(cat, slot) }
    end

    def self.feat_slots_total(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      totals = FEAT_SLOT_TYPES.each_with_object({}) { |t, h| h[t] = 0 }
      return totals unless sheet

      level = [sheet.level.to_i, 1].max

      UNIVERSAL_FEAT_SLOT_LEVELS.each do |slot_type, levels|
        totals[slot_type] = levels.count { |lvl| lvl <= level }
      end

      cc = sheet.charclass || {}
      class_slug = (cc["slug"] || cc[:slug]).to_s.strip.downcase
      entry = read_data("charclasses", class_slug) if !class_slug.empty?

      if entry.is_a?(Hash)
        fbl = entry["features_by_level"] || {}
        fbl.each do |lvl_key, features|
          next if lvl_key.to_i > level
          Array(features).each do |feat_key|
            key = feat_key.to_s.strip.downcase
            if key == "skill_feat"
              totals["skill"] += 1
            elsif key == "general_feat"
              totals["general"] += 1
            elsif key == "ancestry_feat" || key == "combat_feat"
              totals["ancestry"] += 1
            elsif key.end_with?("_feat") || key == "class_feat"
              totals["class"] += 1
            end
          end
        end
      end

      totals
    end

    def self.feat_slots_used(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      used = FEAT_SLOT_TYPES.each_with_object({}) { |t, h| h[t] = 0 }
      return used unless sheet

      map = sheet.feat_slot_map || {}
      map.each_value do |slot|
        key = normalize_feat_slot(slot)
        used[key] += 1 if FEAT_SLOT_TYPES.include?(key)
      end
      used
    end

    def self.feat_slots_remaining(char_or_sheet)
      total = feat_slots_total(char_or_sheet)
      used = feat_slots_used(char_or_sheet)
      FEAT_SLOT_TYPES.each_with_object({}) do |t, h|
        h[t] = [total[t] - used[t], 0].max
      end
    end

    def self.feat_slots_status(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      {
        total: feat_slots_total(sheet),
        used: feat_slots_used(sheet),
        remaining: feat_slots_remaining(sheet),
        map: (sheet && sheet.feat_slot_map) ? sheet.feat_slot_map.dup : {}
      }
    end

    def self.feat_available_slots_for(char_or_sheet, feat_slug)
      entry = feat_entry(feat_slug)
      return [] unless entry
      allowed = feat_slot_types_for(entry)
      remaining = feat_slots_remaining(char_or_sheet)
      allowed.select { |t| remaining[t].to_i > 0 }
    end

    def self.feat_slot_marker?(key)
      k = key.to_s.strip.downcase
      return true if %w[skill_feat general_feat class_feat ancestry_feat combat_feat].include?(k)
      k.end_with?("_feat")
    end

  end
end
