module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Feat slot economy
    # Types: general, combat, class, skill
    # A feat lists which types can pay for it (YAML slots:).
    # Category enforcement: the feat's category must also be
    # legal for the chosen slot (see SLOT_ALLOWED_CATEGORIES).
    # -------------------------------------------------

    FEAT_SLOT_TYPES = %w[general combat class skill].freeze

    # Levels that grant a free universal slot of this type (independent of class).
    # Combat uses the ancestry-feat cadence; general uses the general-feat cadence.
    UNIVERSAL_FEAT_SLOT_LEVELS = {
      "combat"  => [1, 5, 9, 13, 17].freeze,
      "general" => [3, 7, 11, 15, 19].freeze
    }.freeze

    # Which feat categories may be paid for by each slot type.
    # (slots: on the feat is still required; this is a second gate.)
    SLOT_ALLOWED_CATEGORIES = {
      "general" => %w[general skill].freeze,
      "skill"   => %w[skill].freeze,
      "class"   => %w[class dedication archetype].freeze,
      "combat"  => %w[combat ancestry].freeze
    }.freeze

    def self.feat_slot_type?(name)
      FEAT_SLOT_TYPES.include?(name.to_s.strip.downcase)
    end

    def self.feat_category(entry_or_slug)
      entry = entry_or_slug.is_a?(Hash) ? entry_or_slug : feat_entry(entry_or_slug)
      return "" unless entry.is_a?(Hash)
      entry["category"].to_s.strip.downcase
    end

    # True if this feat category is allowed to spend this slot type.
    def self.feat_category_allows_slot?(category, slot_type)
      cat = category.to_s.strip.downcase
      slot = slot_type.to_s.strip.downcase
      allowed = SLOT_ALLOWED_CATEGORIES[slot]
      return false unless allowed
      allowed.include?(cat)
    end

    # Which slot types may pay for this feat (from YAML, or inferred from category),
    # intersected with category enforcement rules.
    def self.feat_slot_types_for(entry_or_slug)
      entry = entry_or_slug.is_a?(Hash) ? entry_or_slug : feat_entry(entry_or_slug)
      return [] unless entry.is_a?(Hash)

      cat = feat_category(entry)

      raw = entry["slots"] || entry["slot_types"]
      candidates = if raw.is_a?(Array) && raw.any?
                     raw.map { |s| s.to_s.strip.downcase }.select { |s| feat_slot_type?(s) }
                   else
                     case cat
                     when "skill" then %w[skill general]
                     when "general" then %w[general]
                     when "class", "dedication", "archetype" then %w[class]
                     when "combat", "ancestry" then %w[combat]
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
            elsif key == "combat_feat" || key == "ancestry_feat"
              totals["combat"] += 1
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
        key = slot.to_s.strip.downcase
        used[key] += 1 if feat_slot_type?(key)
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
