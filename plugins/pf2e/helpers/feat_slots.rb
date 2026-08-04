module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Feat slot economy (PF2e Remaster)
    # Types: ancestry, general, class, skill
    # Universal cadence:
    #   ancestry feats — 1, 5, 9, 13, 17
    #   general feats  — 3, 7, 11, 15, 19
    # Class/skill slots from advancement[level] integer keys
    # (class_feat, skill_feat) or legacy features_by_level markers.
    # -------------------------------------------------

    FEAT_SLOT_TYPES = %w[ancestry general class skill].freeze

    UNIVERSAL_FEAT_SLOT_LEVELS = {
      "ancestry" => [1, 5, 9, 13, 17].freeze,
      "general"  => [3, 7, 11, 15, 19].freeze
    }.freeze

    SLOT_ALLOWED_CATEGORIES = {
      "general"  => %w[general skill].freeze,
      "skill"    => %w[skill].freeze,
      "class"    => %w[class dedication archetype].freeze,
      "ancestry" => %w[ancestry].freeze
    }.freeze

    def self.normalize_feat_slot(name)
      remaster_slot(name)
    end

    def self.feat_slot_type?(name)
      FEAT_SLOT_TYPES.include?(normalize_feat_slot(name))
    end

    def self.feat_category(entry_or_slug)
      entry = entry_or_slug.is_a?(Hash) ? entry_or_slug : feat_entry(entry_or_slug)
      return "" unless entry.is_a?(Hash)
      cat = entry["category"].to_s.strip.downcase
      remaster_slot(cat) # combat → ancestry
    end

    def self.feat_category_allows_slot?(category, slot_type)
      cat = remaster_slot(category.to_s.strip.downcase)
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

      entry = class_entry_for_sheet(sheet)
      if entry
        add_class_slot_grants!(totals, entry, level)
      end

      totals
    end

    def self.add_class_slot_grants!(totals, entry, level)
      adv = entry["advancement"]
      if adv.is_a?(Hash)
        adv.each do |lvl_key, package|
          next if lvl_key.to_i > level
          next unless package.is_a?(Hash)
          totals["class"] += package["class_feat"].to_i
          totals["skill"] += package["skill_feat"].to_i
          totals["general"] += package["general_feat"].to_i
          totals["ancestry"] += package["ancestry_feat"].to_i
        end
        return
      end

      # Legacy features_by_level markers
      (entry["features_by_level"] || {}).each do |lvl_key, features|
        next if lvl_key.to_i > level
        Array(features).each do |feat_key|
          slot = slot_type_for_marker(feat_key)
          totals[slot] += 1 if slot && totals.key?(slot)
        end
      end
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

  end
end
