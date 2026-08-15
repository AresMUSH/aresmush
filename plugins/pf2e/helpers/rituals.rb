module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Rituals
    #
    # Catalog entries live under spells: with category: ritual
    # (see data/spells_rituals.yml). This is not a spell-slot track:
    # casting is a timed activity + skill check(s), resolved at the table.
    #
    # Optional catalog keys (add as data is enriched):
    #   primary_skill / primary_skills — slug or list
    #   min_proficiency — T/E/M/L required on the primary skill
    #   cost_gp — material cost hint
    #   secondary_casters — suggested count
    #   dc — fixed DC override (else derived from rank)
    # -------------------------------------------------

    def self.ritual_entry(slug)
      return nil if slug.nil?
      key = slug.to_s.strip.downcase
      entry = spell_entry(key)
      return nil unless entry.is_a?(Hash)
      return nil unless entry["category"].to_s.downcase == "ritual"
      entry.merge("slug" => key)
    end

    def self.ritual?(slug_or_entry)
      if slug_or_entry.is_a?(Hash)
        slug_or_entry["category"].to_s.downcase == "ritual"
      else
        !ritual_entry(slug_or_entry).nil?
      end
    end

    def self.list_rituals
      all = read_data("spells") || {}
      all.each_with_object([]) do |(slug, entry), acc|
        next unless entry.is_a?(Hash)
        next unless entry["category"].to_s.downcase == "ritual"
        acc << entry.merge("slug" => slug.to_s)
      end.sort_by { |e| [e["rank"].to_i, e["name"].to_s.downcase] }
    end

    def self.ritual_search(query = nil)
      list = list_rituals
      return list if query.nil? || query.to_s.strip.empty?

      q = query.to_s.strip.downcase
      if q =~ /^r(?:ank)?\s*(\d+)$/ || q =~ /^(\d+)$/
        rank = ($1 || q).to_i
        return list.select { |e| e["rank"].to_i == rank }
      end

      list.select do |e|
        hay = [
          e["slug"], e["name"], e["traits"], e["rarity"],
          e["primary_skill"], e["cost_gp"], e["cast"]
        ].flatten.compact.map { |x| x.to_s.downcase }.join(" ")
        hay.include?(q)
      end
    end

    # Ritual level used for DC bands: rank maps to a character level band.
    # Rank 1 → 2, rank 2 → 4, … rank 10 → 20 (spell-rank × 2).
    def self.ritual_level_for_dc(rank)
      r = [rank.to_i, 1].max
      [r * 2, 20].min
    end

    # Default DC: very hard at the ritual's level band, unless entry sets dc.
    def self.ritual_dc(slug_or_entry)
      entry = slug_or_entry.is_a?(Hash) ? slug_or_entry : ritual_entry(slug_or_entry)
      return nil unless entry
      return entry["dc"].to_i if entry["dc"]

      simple_dc(ritual_level_for_dc(entry["rank"]), :very_hard)
    end

    def self.ritual_primary_skills(entry)
      return [] unless entry.is_a?(Hash)
      skills = entry["primary_skills"] || entry["primary_skill"]
      Array(skills).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
    end

    def self.ritual_min_proficiency(entry)
      return "U" unless entry.is_a?(Hash)
      (entry["min_proficiency"] || entry["min_rank"] || "T").to_s.upcase
    end

    def self.format_ritual_line(entry)
      slug = entry["slug"] || ""
      name = entry["name"] || slug
      rank = entry["rank"].to_i
      cast = entry["cast"] || "—"
      rarity = entry["rarity"] || "common"
      skills = ritual_primary_skills(entry)
      skill_bit = skills.any? ? " skill=#{skills.join('|')}" : ""
      dc = ritual_dc(entry)
      "%xh#{slug}%xn - #{name} [R#{rank}/ritual] DC #{dc}#{skill_bit} (#{cast}, #{rarity})"
    end

    def self.format_ritual_detail(entry)
      lines = []
      lines << "%xh#{entry['name'] || entry['slug']}%xn  (#{entry['slug']})"
      lines << "  Rank #{entry['rank']} ritual  |  Cast: #{entry['cast'] || '—'}  |  Rarity: #{entry['rarity'] || 'common'}"
      lines << "  DC #{ritual_dc(entry)} (override in data with dc: N if fixed in the text)"
      skills = ritual_primary_skills(entry)
      if skills.any?
        lines << "  Primary skill(s): #{skills.join(', ')} (min #{ritual_min_proficiency(entry)})"
      else
        lines << "  Primary skill(s): not set in data — pass skill on rituals/check"
      end
      lines << "  Cost (gp): #{entry['cost_gp']}" if entry["cost_gp"]
      lines << "  Secondary casters: #{entry['secondary_casters']}" if entry["secondary_casters"]
      traits = Array(entry["traits"])
      lines << "  Traits: #{traits.join(', ')}" if traits.any?
      lines << "  Range: #{entry['range']}" if entry["range"]
      lines << "  Target: #{entry['target']}" if entry["target"]
      lines << "  Area: #{entry['area']}" if entry["area"]
      lines << "  Duration: #{entry['duration']}" if entry["duration"]
      lines << "  Source: #{entry['source']}" if entry["source"]
      lines << "  %xEffects and full requirements: use AON / book at the table.%xn"
      lines.join("%r")
    end

    # Primary ritual check. Does not spend slots/focus/items — table narration owns the rest.
    def self.ritual_primary_check(char_or_sheet, slug, skill: nil, other_bonus: 0, dc: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      entry = ritual_entry(slug)
      return { ok: false, error: "pf2e.ritual_unknown", ritual: slug.to_s } unless entry

      skills = ritual_primary_skills(entry)
      chosen = skill.to_s.strip.downcase
      if chosen.empty?
        if skills.size == 1
          chosen = skills.first
        elsif skills.empty?
          return { ok: false, error: "pf2e.ritual_skill_required", ritual: entry["slug"] }
        else
          return {
            ok: false,
            error: "pf2e.ritual_skill_ambiguous",
            ritual: entry["slug"],
            skills: skills
          }
        end
      end

      unless skill_ability(chosen)
        return { ok: false, error: "pf2e.cg_unknown_skill", skill: chosen }
      end

      if skills.any? && !skills.include?(chosen)
        return {
          ok: false,
          error: "pf2e.ritual_skill_not_listed",
          ritual: entry["slug"],
          skill: chosen,
          skills: skills
        }
      end

      min_rank = ritual_min_proficiency(entry)
      have = skill_rank(sheet, chosen)
      if teml_to_bonus(have) < teml_to_bonus(min_rank)
        return {
          ok: false,
          error: "pf2e.ritual_skill_rank",
          skill: chosen,
          have: have,
          need: min_rank
        }
      end

      target_dc = dc.nil? ? ritual_dc(entry) : dc.to_i
      roll = skill_roll(sheet, chosen, other_bonus: other_bonus, dc: target_dc)

      {
        ok: true,
        error: nil,
        ritual: entry["slug"],
        name: entry["name"],
        rank: entry["rank"].to_i,
        skill: chosen,
        skill_rank: have,
        dc: target_dc,
        total: roll[:total],
        d20: roll[:d20],
        mod: roll[:mod],
        degree: roll[:degree],
        breakdown: roll,
        cast: entry["cast"],
        cost_gp: entry["cost_gp"]
      }
    end

  end
end
