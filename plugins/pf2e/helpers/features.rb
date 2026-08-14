module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Automatic ancestry / class feature grants
    #
    # Prefer class entry["advancement"][level]["features"].
    # Legacy entry["features_by_level"] still loads: real feature
    # slugs only; *_feat markers are slots, not features.
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
      expected
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
