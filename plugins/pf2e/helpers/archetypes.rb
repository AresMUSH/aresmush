module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Archetypes / dedications
    # Sheet.archetypes = list of archetype slugs the character has dedicated into.
    # Taking a dedication feat registers the archetype and applies YAML grants.
    # -------------------------------------------------

    def self.archetype_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("archetypes", slug.to_s.strip.downcase)
    end

    def self.archetype_data
      read_data("archetypes") || {}
    end

    def self.sheet_archetypes(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return [] unless sheet
      Array(sheet.archetypes).map { |a| a.to_s.strip.downcase }.reject(&:empty?).uniq
    end

    def self.has_archetype?(char_or_sheet, slug)
      sheet_archetypes(char_or_sheet).include?(slug.to_s.strip.downcase)
    end

    # Find archetype whose dedication_feat matches this feat slug.
    def self.archetype_for_dedication_feat(feat_slug)
      key = feat_slug.to_s.strip.downcase
      archetype_data.each do |slug, entry|
        next unless entry.is_a?(Hash)
        if entry["dedication_feat"].to_s.strip.downcase == key
          return [slug.to_s, entry]
        end
      end
      nil
    end

    # Archetype slug referenced by a feat (traits include archetype name, or archetype: key).
    def self.feat_archetype_slug(entry)
      return nil unless entry.is_a?(Hash)
      explicit = entry["archetype"].to_s.strip.downcase
      return explicit unless explicit.empty?

      traits = Array(entry["traits"]).map { |t| t.to_s.strip.downcase }
      return nil unless traits.include?("archetype") || traits.include?("dedication")

      # Prefer a trait that matches a known archetype key
      data = archetype_data
      traits.each do |t|
        next if %w[archetype dedication multiclass].include?(t)
        return t if data.key?(t)
      end
      nil
    end

    def self.dedication_feat?(entry_or_slug)
      entry = entry_or_slug.is_a?(Hash) ? entry_or_slug : feat_entry(entry_or_slug)
      return false unless entry.is_a?(Hash)
      traits = Array(entry["traits"]).map { |t| t.to_s.downcase }
      return true if traits.include?("dedication")
      !archetype_for_dedication_feat(entry_or_slug.is_a?(Hash) ? nil : entry_or_slug).nil? rescue false
    end

    def self.dedication_feat_for_entry?(entry, slug)
      return false unless entry.is_a?(Hash)
      traits = Array(entry["traits"]).map { |t| t.to_s.downcase }
      return true if traits.include?("dedication")
      pair = archetype_for_dedication_feat(slug)
      !pair.nil?
    end

    # Multiclass rule: cannot take dedication for a class you already are.
    def self.archetype_multiclass_blocked?(sheet, arch_slug)
      entry = archetype_entry(arch_slug)
      return false unless entry.is_a?(Hash)
      return false unless entry["multiclass"]

      class_slug = entry["class_slug"].to_s.strip.downcase
      return false if class_slug.empty?

      cc = sheet.charclass || {}
      have = (cc["slug"] || cc[:slug]).to_s.strip.downcase
      have == class_slug
    end

    def self.archetype_grants_skills(sheet, arch_entry)
      return unless arch_entry.is_a?(Hash)
      grants = arch_entry["grants"] || {}
      Array(grants["skills"]).each do |sk|
        key = sk.to_s.strip.downcase
        next if key.empty?
        set_skill_rank(sheet, key, "T") if skill_rank(sheet, key) == "U"
      end
    end

    # Called after a dedication feat is successfully taken.
    def self.archetype_on_dedication_taken(sheet, feat_slug)
      pair = archetype_for_dedication_feat(feat_slug)
      return nil unless pair
      arch_slug, entry = pair

      list = sheet_archetypes(sheet)
      unless list.include?(arch_slug)
        list << arch_slug
        sheet.update(archetypes: list)
      end
      archetype_grants_skills(sheet, entry)
      arch_slug
    end

    # Feats belonging to this archetype (excluding the dedication itself).
    def self.archetype_dependent_feat_slugs(arch_slug)
      arch_slug = arch_slug.to_s.strip.downcase
      entry = archetype_entry(arch_slug)
      dedication = entry.is_a?(Hash) ? entry["dedication_feat"].to_s.strip.downcase : ""

      deps = []
      (read_data("feats") || {}).each do |slug, fentry|
        next unless fentry.is_a?(Hash)
        s = slug.to_s.strip.downcase
        next if s == dedication
        if feat_archetype_slug(fentry) == arch_slug
          deps << s
        end
      end
      deps
    end

    # True if sheet still owns non-dedication feats from this archetype.
    def self.archetype_has_dependent_feats?(sheet, arch_slug)
      owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
      archetype_dependent_feat_slugs(arch_slug).any? { |s| owned.include?(s) }
    end

    # Called before removing a dedication feat. Returns error hash or nil.
    def self.archetype_can_remove_dedication?(sheet, feat_slug)
      pair = archetype_for_dedication_feat(feat_slug)
      return nil unless pair
      arch_slug, = pair
      if archetype_has_dependent_feats?(sheet, arch_slug)
        return { ok: false, error: "pf2e.cg_dedication_has_dependents", archetype: arch_slug }
      end
      nil
    end

    def self.archetype_on_dedication_removed(sheet, feat_slug)
      pair = archetype_for_dedication_feat(feat_slug)
      return unless pair
      arch_slug, = pair
      list = sheet_archetypes(sheet)
      list.delete(arch_slug)
      sheet.update(archetypes: list)
    end

  end
end
