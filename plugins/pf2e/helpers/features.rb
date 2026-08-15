module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Automatic ancestry / class feature grants
    #
    # Prefer class entry["advancement"][level]["features"].
    # Legacy entry["features_by_level"] still loads: real feature
    # slugs only; *_feat markers are slots, not features.
    #
    # Ancestry / heritage may also list innate_spells:
    #   innate_spells:
    #     - slug: detect_magic
    #       tradition: arcane
    #       frequency: at_will   # or per_day
    #       per_day: 1
    #       rank: 0
    #       attribute: cha       # optional
    # -------------------------------------------------

    def self.feat_slot_marker?(key)
      k = key.to_s.strip.downcase
      return true if slot_type_for_marker(k)
      false
    end

    def self.sheet_features(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return [] unless sheet
      Array(sheet.features).map { |f| f.to_s.strip.downcase }.reject(&:empty?).uniq
    end

    def self.add_feature(sheet, slug)
      key = slug.to_s.strip.downcase
      return false if key.empty?
      list = sheet_features(sheet)
      return true if list.include?(key)
      list << key
      sheet.update(features: list)
      true
    end

    def self.ancestry_feature_slugs(sheet)
      anc = cg_ancestry_entry(sheet.ancestry)
      return [] unless anc.is_a?(Hash)
      Array(anc["features"]).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
    end

    def self.heritage_feature_slugs(sheet)
      her = cg_heritage_entry(sheet.heritage)
      return [] unless her.is_a?(Hash)
      Array(her["features"]).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
    end

    def self.class_feature_slugs(sheet)
      entry = class_entry_for_sheet(sheet)
      return [] unless entry
      level = [sheet.level.to_i, 1].max
      granted = []

      adv = entry["advancement"]
      if adv.is_a?(Hash)
        adv.each do |lvl_key, package|
          next if lvl_key.to_i > level
          next unless package.is_a?(Hash)
          Array(package["features"]).each do |feat_key|
            key = feat_key.to_s.strip.downcase
            next if key.empty? || feat_slot_marker?(key)
            granted << key
          end
        end
      else
        # Legacy features_by_level
        (entry["features_by_level"] || {}).each do |lvl_key, features|
          next if lvl_key.to_i > level
          Array(features).each do |feat_key|
            key = feat_key.to_s.strip.downcase
            next if key.empty? || feat_slot_marker?(key)
            granted << key
          end
        end
      end
      granted.uniq
    end

    def self.expected_feature_slugs(sheet)
      (
        ancestry_feature_slugs(sheet) +
        heritage_feature_slugs(sheet) +
        class_feature_slugs(sheet)
      ).uniq
    end

    def self.cg_apply_granted_features(sheet)
      return [] unless sheet
      expected = expected_feature_slugs(sheet)
      sheet.update(features: expected)
      apply_identity_innate_spells!(sheet)
      expected
    end

    # Pull innate_spells lists from ancestry + heritage YAML and grant them.
    # Does not remove staff- or feat-granted innates that are not in the lists.
    def self.apply_identity_innate_spells!(sheet)
      return unless sheet

      grants = []
      anc = cg_ancestry_entry(sheet.ancestry)
      if anc.is_a?(Hash)
        Array(anc["innate_spells"]).each do |row|
          grants << normalize_innate_grant_row(row, "ancestry:#{sheet.ancestry}")
        end
      end
      her = cg_heritage_entry(sheet.heritage)
      if her.is_a?(Hash)
        Array(her["innate_spells"]).each do |row|
          grants << normalize_innate_grant_row(row, "heritage:#{sheet.heritage}")
        end
      end

      grants.compact.each do |g|
        innate_grant(
          sheet,
          slug: g[:slug],
          tradition: g[:tradition],
          rank: g[:rank],
          frequency: g[:frequency],
          per_day: g[:per_day],
          attribute: g[:attribute],
          grant: g[:grant]
        )
      end
    end

    def self.normalize_innate_grant_row(row, grant_label)
      return nil if row.nil?
      if row.is_a?(String)
        return {
          slug: row.to_s.strip.downcase,
          tradition: nil,
          rank: nil,
          frequency: nil,
          per_day: 1,
          attribute: nil,
          grant: grant_label
        }
      end
      return nil unless row.is_a?(Hash)

      slug = (row["slug"] || row["spell"] || row[:slug] || row[:spell]).to_s.strip.downcase
      return nil if slug.empty?

      {
        slug: slug,
        tradition: row["tradition"] || row[:tradition],
        rank: row.key?("rank") || row.key?(:rank) ? (row["rank"] || row[:rank]).to_i : nil,
        frequency: row["frequency"] || row[:frequency],
        per_day: (row["per_day"] || row[:per_day] || 1).to_i,
        attribute: row["attribute"] || row["ability"] || row[:attribute],
        grant: grant_label
      }
    end

    def self.has_feature?(char_or_sheet, slug)
      sheet_features(char_or_sheet).include?(slug.to_s.strip.downcase)
    end

    def self.class_entry_for_sheet(sheet)
      return nil unless sheet
      cc = sheet.charclass || {}
      class_slug = (cc["slug"] || cc[:slug]).to_s.strip.downcase
      return nil if class_slug.empty?
      entry = read_data("charclasses", class_slug)
      entry.is_a?(Hash) ? entry : nil
    end

  end
end
