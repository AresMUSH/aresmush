module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Automatic ancestry / class feature grants
    # Slot markers (skill_feat, fighter_feat, …) are NOT features —
    # they only add to the feat-slot budget. Everything else under
    # features_by_level and ancestry.features is stored on sheet.features.
    # -------------------------------------------------

    # Keys that grant a feat *slot* rather than a fixed feature.
    FEAT_SLOT_MARKERS = %w[
      skill_feat class_feat general_feat combat_feat ancestry_feat
    ].freeze

    def self.feat_slot_marker?(key)
      k = key.to_s.strip.downcase
      return true if FEAT_SLOT_MARKERS.include?(k)
      # fighter_feat, wizard_feat, rogue_feat, druid_feat, …
      k.end_with?("_feat")
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

    # Ancestry baseline features (darkvision, clan_dagger, …).
    def self.ancestry_feature_slugs(sheet)
      anc = cg_ancestry_entry(sheet.ancestry)
      return [] unless anc.is_a?(Hash)
      Array(anc["features"]).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
    end

    # Heritage optional features list if present.
    def self.heritage_feature_slugs(sheet)
      her = cg_heritage_entry(sheet.heritage)
      return [] unless her.is_a?(Hash)
      Array(her["features"]).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
    end

    # Class features at or below current level, excluding slot markers.
    def self.class_feature_slugs(sheet)
      cc = sheet.charclass || {}
      class_slug = (cc["slug"] || cc[:slug]).to_s.strip.downcase
      return [] if class_slug.empty?
      entry = read_data("charclasses", class_slug)
      return [] unless entry.is_a?(Hash)

      level = [sheet.level.to_i, 1].max
      granted = []
      (entry["features_by_level"] || {}).each do |lvl_key, features|
        next if lvl_key.to_i > level
        Array(features).each do |feat_key|
          key = feat_key.to_s.strip.downcase
          next if key.empty?
          next if feat_slot_marker?(key)
          granted << key
        end
      end
      granted.uniq
    end

    # Full set of automatic features the sheet should have right now.
    def self.expected_feature_slugs(sheet)
      (
        ancestry_feature_slugs(sheet) +
        heritage_feature_slugs(sheet) +
        class_feature_slugs(sheet)
      ).uniq
    end

    # Rebuild sheet.features from ancestry + heritage + class (≤ level).
    # Does not touch feats / feat_slot_map.
    def self.cg_apply_granted_features(sheet)
      return [] unless sheet
      expected = expected_feature_slugs(sheet)
      sheet.update(features: expected)
      expected
    end

    def self.has_feature?(char_or_sheet, slug)
      sheet_features(char_or_sheet).include?(slug.to_s.strip.downcase)
    end

  end
end
