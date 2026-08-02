module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Feat helpers
    # Prerequisites, eligibility lists, search, chargen.
    # -------------------------------------------------

    def self.feat_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("feats", slug.to_s.strip.downcase)
    end

    def self.feat_prereq_block(entry)
      return nil unless entry.is_a?(Hash)
      entry["prerequisites"] || entry["prereqs"]
    end

    def self.feat_check_prereq_node(sheet, node)
      return nil unless node.is_a?(Hash)

      type = node["type"].to_s.strip.downcase

      case type
      when "ability", "attribute"
        abil = ability_key(node["ability"] || node["attribute"])
        min  = node["min"].to_i
        return "Need ability score" unless abil
        score = ability_score(sheet, abil) || 0
        score >= min ? nil : "Need #{abil.upcase} #{min} (have #{score})"

      when "skill"
        skill = node["skill"].to_s.strip.downcase
        rank  = (node["rank"] || "T").to_s
        actual = skill_rank(sheet, skill)
        teml_at_least?(actual, rank) ? nil : "Need #{skill} #{rank.upcase} (have #{actual})"

      when "save"
        save = node["save"].to_s.strip.downcase
        rank = (node["rank"] || "T").to_s
        actual = save_rank(sheet, save)
        teml_at_least?(actual, rank) ? nil : "Need #{save} #{rank.upcase} (have #{actual})"

      when "feat"
        need = node["slug"].to_s.strip.downcase
        owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
        owned.include?(need) ? nil : "Need feat: #{need}"

      when "feats"
        slugs = Array(node["slugs"]).map { |s| s.to_s.strip.downcase }
        mode  = (node["mode"] || "all").to_s.downcase
        owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
        if mode == "any"
          slugs.any? { |s| owned.include?(s) } ? nil : "Need one of feats: #{slugs.join(', ')}"
        else
          missing = slugs.reject { |s| owned.include?(s) }
          missing.empty? ? nil : "Need feats: #{missing.join(', ')}"
        end

      when "class"
        need = node["slug"].to_s.strip.downcase
        cc = sheet.charclass || {}
        have = (cc["slug"] || cc[:slug]).to_s.strip.downcase
        have == need ? nil : "Need class: #{need} (have #{have.empty? ? 'none' : have})"

      when "ancestry"
        need = node["slug"].to_s.strip.downcase
        have = sheet.ancestry.to_s.strip.downcase
        have == need ? nil : "Need ancestry: #{need} (have #{have.empty? ? 'none' : have})"

      when "heritage"
        need = node["slug"].to_s.strip.downcase
        have = sheet.heritage.to_s.strip.downcase
        have == need ? nil : "Need heritage: #{need} (have #{have.empty? ? 'none' : have})"

      when "level"
        min = node["min"].to_i
        lvl = sheet.level.to_i
        lvl >= min ? nil : "Need level #{min} (have #{lvl})"

      when "trait"
        trait = node["trait"].to_s.strip.downcase
        bag = [
          sheet.ancestry.to_s,
          sheet.heritage.to_s,
          (sheet.charclass || {})["slug"].to_s,
          (sheet.charclass || {})[:slug].to_s
        ].map { |s| s.strip.downcase }
        bag.include?(trait) ? nil : "Need trait/source: #{trait}"

      when "group"
        failures = []
        Array(node["all"]).each do |child|
          msg = feat_check_prereq_node(sheet, child)
          failures << msg if msg
        end
        return failures.first if failures.any?

        any_nodes = Array(node["any"])
        if any_nodes.any?
          any_ok = any_nodes.any? { |child| feat_check_prereq_node(sheet, child).nil? }
          return "No alternate prerequisite met" unless any_ok
        end

        Array(node["none"]).each do |child|
          msg = feat_check_prereq_node(sheet, child)
          return "Forbidden prerequisite present" if msg.nil?
        end
        nil

      else
        nil
      end
    end

    def self.feat_check_flat_prereqs(sheet, prereqs)
      failures = []
      return failures unless prereqs.is_a?(Hash)

      if prereqs.key?("level") || prereqs.key?(:level)
        min = (prereqs["level"] || prereqs[:level]).to_i
        lvl = sheet.level.to_i
        failures << "Need level #{min} (have #{lvl})" if lvl < min
      end

      skills = prereqs["skills"] || prereqs[:skills]
      if skills.is_a?(Hash)
        skills.each do |skill, rank|
          next if skill.to_s.empty?
          next if rank.nil? || rank.to_s.strip.empty?
          actual = skill_rank(sheet, skill)
          unless teml_at_least?(actual, rank)
            failures << "Need #{skill} #{rank.to_s.upcase} (have #{actual})"
          end
        end
      end

      attrs = prereqs["attributes"] || prereqs[:attributes] || prereqs["abilities"]
      if attrs.is_a?(Hash)
        attrs.each do |abil_raw, min|
          abil = ability_key(abil_raw)
          next unless abil
          score = ability_score(sheet, abil) || 0
          failures << "Need #{abil.upcase} #{min.to_i} (have #{score})" if score < min.to_i
        end
      end

      saves = prereqs["saves"] || prereqs[:saves]
      if saves.is_a?(Hash)
        saves.each do |save, rank|
          next if rank.nil? || rank.to_s.strip.empty?
          actual = save_rank(sheet, save)
          unless teml_at_least?(actual, rank)
            failures << "Need #{save} #{rank.to_s.upcase} (have #{actual})"
          end
        end
      end

      feat_list = prereqs["feats"] || prereqs[:feats]
      if feat_list
        owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
        Array(feat_list).each do |need|
          n = need.to_s.strip.downcase
          next if n.empty?
          failures << "Need feat: #{n}" unless owned.include?(n)
        end
      end

      failures
    end

    def self.feat_prereqs_met?(char_or_sheet, feat_slug)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, failures: ["No sheet"] } unless sheet

      key = feat_slug.to_s.strip.downcase
      entry = feat_entry(key)
      return { ok: false, failures: ["Unknown feat: #{key}"] } unless entry.is_a?(Hash)

      failures = []

      feat_level = entry["level"].to_i
      if feat_level > 0 && sheet.level.to_i < feat_level
        failures << "Need level #{feat_level} (have #{sheet.level.to_i})"
      end

      prereqs = feat_prereq_block(entry)

      if prereqs.nil? || prereqs == {} || prereqs == []
        return { ok: failures.empty?, failures: failures }
      end

      unless prereqs.is_a?(Hash)
        return { ok: failures.empty?, failures: failures }
      end

      structured = prereqs.key?("all") || prereqs.key?("any") || prereqs.key?("none") ||
                   prereqs.key?(:all) || prereqs.key?(:any) || prereqs.key?(:none)

      if structured
        Array(prereqs["all"] || prereqs[:all]).each do |node|
          msg = feat_check_prereq_node(sheet, node)
          failures << msg if msg
        end

        any_nodes = Array(prereqs["any"] || prereqs[:any])
        if any_nodes.any?
          any_ok = any_nodes.any? { |node| feat_check_prereq_node(sheet, node).nil? }
          failures << "No alternate prerequisite met" unless any_ok
        end

        Array(prereqs["none"] || prereqs[:none]).each do |node|
          msg = feat_check_prereq_node(sheet, node)
          failures << "Forbidden prerequisite present" if msg.nil?
        end
      else
        failures.concat(feat_check_flat_prereqs(sheet, prereqs))
      end

      { ok: failures.empty?, failures: failures }
    end

    def self.feat_eligible_list(char_or_sheet, category: nil, trait: nil, include_owned: false, max_level: nil)
      sheet = sheet_for(char_or_sheet)
      return [] unless sheet

      data = read_data("feats") || {}
      owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
      level_cap = max_level.nil? ? sheet.level.to_i : max_level.to_i

      rows = []
      data.each do |slug, entry|
        next unless entry.is_a?(Hash)
        slug = slug.to_s

        next if !include_owned && owned.include?(slug)

        feat_level = entry["level"].to_i
        next if feat_level > level_cap && feat_level > 0

        if category
          cat = entry["category"].to_s.strip.downcase
          next unless cat == category.to_s.strip.downcase
        end

        if trait
          traits = Array(entry["traits"]).map { |t| t.to_s.strip.downcase }
          next unless traits.include?(trait.to_s.strip.downcase)
        end

        check = feat_prereqs_met?(sheet, slug)
        next unless check[:ok]

        rows << {
          slug: slug,
          name: entry["name"] || slug,
          level: feat_level,
          category: entry["category"].to_s,
          traits: Array(entry["traits"]).map(&:to_s),
          action: entry["action"]
        }
      end

      rows.sort_by { |r| [r[:level], r[:name].to_s.downcase] }
    end

    # Search feats by name/slug, level, category/trait, or free text in effect.
    # query blank → all feats sorted by level then name.
    def self.feat_search(query = nil)
      data = read_data("feats") || {}
      q = query.to_s.strip.downcase

      rows = []
      data.each do |slug, entry|
        next unless entry.is_a?(Hash)
        slug = slug.to_s
        name = (entry["name"] || slug).to_s
        level = entry["level"].to_i
        category = entry["category"].to_s
        traits = Array(entry["traits"]).map(&:to_s)
        effect = entry["effect"].to_s
        tags = Array(entry["tags"]).map(&:to_s)

        if !q.empty?
          if q =~ /\A\d+\z/
            next unless level == q.to_i
          else
            haystack = [
              slug, name.downcase, category.downcase,
              traits.map(&:downcase).join(" "),
              tags.map(&:downcase).join(" "),
              effect.downcase
            ].join(" ")
            next unless haystack.include?(q)
          end
        end

        rows << {
          slug: slug,
          name: name,
          level: level,
          category: category,
          traits: traits,
          action: entry["action"],
          effect: effect.strip.gsub(/\s+/, " ")
        }
      end

      rows.sort_by { |r| [r[:level], r[:name].to_s.downcase] }
    end

    def self.cg_take_feat(char, slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      locked = cg_require_identity_locked(sheet)
      return locked if locked

      key = slug.to_s.strip.downcase
      entry = feat_entry(key)
      return { ok: false, error: "pf2e.cg_unknown_feat", sheet: sheet } unless entry.is_a?(Hash)

      owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
      if owned.include?(key)
        return { ok: false, error: "pf2e.cg_feat_owned", sheet: sheet }
      end

      check = feat_prereqs_met?(sheet, key)
      unless check[:ok]
        return {
          ok: false,
          error: "pf2e.cg_feat_prereq",
          sheet: sheet,
          failures: check[:failures]
        }
      end

      owned << key
      sheet.update(feats: owned)

      {
        ok: true,
        error: nil,
        sheet: sheet,
        feat: key,
        name: entry["name"] || key
      }
    end

  end
end
