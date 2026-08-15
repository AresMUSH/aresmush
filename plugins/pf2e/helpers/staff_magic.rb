module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Staff magic seed / grant paths for pf2e/set
    #
    # Usage (all require manage_pf2e):
    #   pf2e/set <name>=magic/sync
    #   pf2e/set <name>=magic/source/<source>/seed     # class table + defaults
    #   pf2e/set <name>=magic/source/<source>/create/<tradition>/<casting>/<attribute>/<rank>
    #   pf2e/set <name>=magic/learn/<source>/<spell>[/<rank>]
    #   pf2e/set <name>=magic/unlearn/<source>/<spell>
    #   pf2e/set <name>=magic/cantrip/<source>/add/<spell>
    #   pf2e/set <name>=magic/cantrip/<source>/remove/<spell>
    #   pf2e/set <name>=magic/focus/<source>/add/<spell>
    #   pf2e/set <name>=magic/focus/<source>/remove/<spell>
    #   pf2e/set <name>=magic/proficiency/<source>/<T|E|M|L>
    #   pf2e/set <name>=magic/daily
    #   pf2e/set <name>=magic/innate/add/<spell>[/tradition][/rank][/at_will|per_day][/N]
    #   pf2e/set <name>=magic/innate/remove/<spell>
    #   pf2e/set <name>=magic/innate/grant/<spell>/...  (alias of add)
    # -------------------------------------------------

    def self.staff_set_magic(enactor, char, sheet, parts, raw_parts)
      action = parts[1]
      return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if action.nil?

      case action
      when "sync"
        sync_all_magic_slots(sheet)
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "magic slots synced for level #{sheet.level}" }

      when "daily", "reset_daily"
        r = magic_daily_reset(sheet)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "daily prep (focus=#{r[:focus_points]}/#{r[:focus_max]})" }

      when "source"
        staff_set_magic_source(char, sheet, parts, raw_parts)

      when "learn"
        source = parts[2]
        spell = parts[3]
        rank = parts[4] ? parts[4].to_i : nil
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if source.nil? || spell.nil?

        # Allow staff to inject even if catalog missing: create a minimal entry via learn path
        if spell_entry(spell).nil?
          # Force into source lists without catalog
          r = staff_magic_inject_spell(sheet, source, spell, rank: rank)
        else
          r = magic_learn(sheet, source, spell, rank: rank)
        end
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "learned #{spell} on #{r[:source]} (rank #{r[:rank]})" }

      when "unlearn", "forget"
        source = parts[2]
        spell = parts[3]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if source.nil? || spell.nil?
        r = staff_magic_unlearn(sheet, source, spell)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "unlearned #{spell} from #{r[:source]}" }

      when "cantrip"
        source = parts[2]
        sub = parts[3]
        spell = parts[4]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if source.nil? || sub.nil? || spell.nil?
        if sub == "add"
          r = staff_magic_inject_spell(sheet, source, spell, rank: 0)
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          { ok: true, error: nil, char: char, sheet: sheet, summary: "cantrip +#{spell} on #{source}" }
        elsif sub == "remove"
          r = staff_magic_unlearn(sheet, source, spell)
          return r.merge(char: char, sheet: sheet) unless r[:ok]
          { ok: true, error: nil, char: char, sheet: sheet, summary: "cantrip -#{spell} on #{source}" }
        else
          { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
        end

      when "focus"
        source = parts[2]
        sub = parts[3]
        spell = parts[4]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if source.nil? || sub.nil? || spell.nil?
        r = staff_magic_focus(sheet, source, spell, add: sub == "add")
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        verb = sub == "add" ? "+" : "-"
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "focus #{verb}#{spell} on #{source}" }

      when "proficiency", "rank", "prof"
        source = parts[2]
        rank = (parts[3] || "").upcase
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if source.nil? || rank.empty?
        unless %w[U T E M L].include?(rank)
          return { ok: false, error: "pf2e.staff_bad_value", char: char, sheet: sheet }
        end
        entry = magic_source(sheet, source)
        return { ok: false, error: "pf2e.magic_unknown_source", char: char, sheet: sheet } unless entry
        set_magic_source(sheet, source, "proficiency" => rank)
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "#{source} proficiency=#{rank}" }

      when "innate"
        staff_set_innate(char, sheet, parts, raw_parts)

      else
        { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
      end
    end

    def self.staff_set_magic_source(char, sheet, parts, raw_parts)
      source = parts[2]
      sub = parts[3]
      return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if source.nil? || sub.nil?

      case sub
      when "seed"
        # Prefer class sync if this is the class slug; otherwise create a minimal source
        class_slug = ((sheet.charclass || {})["slug"]).to_s.downcase
        if source.downcase == class_slug || source.downcase == "class"
          sync_class_magic_source(sheet)
          key = normalize_magic_source(source == "class" ? class_slug : source)
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "seeded class magic source (#{key || class_slug})" }
        else
          ensure_minimal_magic_source(sheet, source)
          sync_all_magic_slots(sheet)
          { ok: true, error: nil, char: char, sheet: sheet,
            summary: "seeded magic source #{normalize_magic_source(source)}" }
        end

      when "create"
        # create/<tradition>/<casting>/<attribute>/<rank>
        tradition = parts[4]
        casting = parts[5] || "prepared"
        attribute = ability_key(parts[6]) || "cha"
        rank = (parts[7] || "T").upcase
        progression = case casting.to_s.downcase
                      when "focus" then "none"
                      when "bounded" then "bounded"
                      else "full"
                      end
        set_magic_source(sheet, source, {
          "tradition" => tradition,
          "casting" => casting,
          "attribute" => attribute,
          "proficiency" => rank,
          "progression" => progression
        })
        sync_all_magic_slots(sheet)
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "created #{normalize_magic_source(source)} #{tradition}/#{casting} #{attribute.upcase} #{rank}" }

      when "remove", "delete"
        key = normalize_magic_source(source)
        magic = magic_hash(sheet).dup
        magic.delete(key)
        sheet.update(magic: magic)
        { ok: true, error: nil, char: char, sheet: sheet, summary: "removed magic source #{key}" }

      else
        { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
      end
    end

    def self.staff_set_innate(char, sheet, parts, raw_parts)
      sub = parts[2]
      spell = parts[3]
      return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if sub.nil?

      case sub
      when "add", "grant"
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if spell.nil?

        # Optional trailing tokens: tradition, rank, frequency, per_day, attribute
        # Order: tradition rank freq per_day attribute
        tradition = nil
        rank = nil
        frequency = nil
        per_day = 1
        attribute = nil

        rest = parts[4..-1] || []
        rest.each do |tok|
          t = tok.to_s.downcase
          if %w[arcane divine occult primal].include?(t)
            tradition = t
          elsif t =~ /^\d+$/
            if frequency.nil? && rank.nil?
              rank = t.to_i
            else
              per_day = t.to_i
            end
          elsif %w[at_will atwill will per_day perday daily].include?(t)
            frequency = (t =~ /will/) ? "at_will" : "per_day"
          elsif ability_key(t)
            attribute = ability_key(t)
          end
        end

        r = innate_grant(sheet,
                         slug: spell,
                         tradition: tradition,
                         rank: rank,
                         frequency: frequency,
                         per_day: per_day,
                         attribute: attribute,
                         grant: "staff:#{char.name}")
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "innate +#{spell} (#{r[:frequency]})" }

      when "remove", "delete"
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if spell.nil?
        r = innate_remove(sheet, spell)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet, summary: "innate -#{spell}" }

      else
        { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
      end
    end

    def self.ensure_minimal_magic_source(sheet, source)
      key = normalize_magic_source(source)
      return if magic_source(sheet, key)
      set_magic_source(sheet, key, default_magic_source.merge(
        "casting" => "prepared",
        "progression" => "full",
        "attribute" => "cha",
        "proficiency" => "T"
      ))
    end

    def self.staff_magic_inject_spell(sheet, source, spell, rank: nil)
      ensure_minimal_magic_source(sheet, source) unless magic_source(sheet, source)
      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      slug = spell.to_s.strip.downcase
      entry = resolved[:entry].dup
      casting = entry["casting"].to_s.downcase
      spell_rank = rank.nil? ? 0 : rank.to_i

      if spell_rank == 0
        cantrips = Array(entry["cantrips"]).map { |s| s.to_s.downcase }
        cantrips << slug unless cantrips.include?(slug)
        entry["cantrips"] = cantrips
      elsif casting == "spontaneous"
        rep = (entry["repertoire"] || {}).dup
        key = spell_rank.to_s
        list = Array(rep[key]).map { |s| s.to_s.downcase }
        list << slug unless list.include?(slug)
        rep[key] = list
        entry["repertoire"] = rep
      else
        book = Array(entry["spellbook"]).map { |s| s.to_s.downcase }
        book << slug unless book.include?(slug)
        entry["spellbook"] = book
      end

      magic = magic_hash(sheet).dup
      magic[resolved[:source]] = entry
      sheet.update(magic: magic)
      { ok: true, source: resolved[:source], spell: slug, rank: spell_rank, casting: casting }
    end

    def self.staff_magic_unlearn(sheet, source, spell)
      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      slug = spell.to_s.strip.downcase
      entry = resolved[:entry].dup
      entry["cantrips"] = Array(entry["cantrips"]).map { |s| s.to_s.downcase }.reject { |s| s == slug }
      entry["spellbook"] = Array(entry["spellbook"]).map { |s| s.to_s.downcase }.reject { |s| s == slug }
      entry["focus_spells"] = Array(entry["focus_spells"]).map { |s| s.to_s.downcase }.reject { |s| s == slug }

      if entry["repertoire"].is_a?(Hash)
        rep = entry["repertoire"].dup
        rep.each do |rk, list|
          rep[rk] = Array(list).map { |s| s.to_s.downcase }.reject { |s| s == slug }
        end
        entry["repertoire"] = rep
      end

      if entry["prepared"].is_a?(Hash)
        prep = entry["prepared"].dup
        prep.each do |rk, list|
          prep[rk] = Array(list).map { |s| s.to_s.downcase }.reject { |s| s == slug }
        end
        entry["prepared"] = prep
      end

      magic = magic_hash(sheet).dup
      magic[resolved[:source]] = entry
      sheet.update(magic: magic)
      { ok: true, source: resolved[:source], spell: slug }
    end

    def self.staff_magic_focus(sheet, source, spell, add:)
      ensure_minimal_magic_source(sheet, source) unless magic_source(sheet, source)
      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      slug = spell.to_s.strip.downcase
      entry = resolved[:entry].dup
      list = Array(entry["focus_spells"]).map { |s| s.to_s.downcase }
      if add
        list << slug unless list.include?(slug)
      else
        list.delete(slug)
      end
      entry["focus_spells"] = list
      magic = magic_hash(sheet).dup
      magic[resolved[:source]] = entry
      sheet.update(magic: magic)

      # First focus spell opens a pool of 1 if max was 0; does not auto-stack max.
      ensure_focus_pool_from_spells!(sheet)

      { ok: true, source: resolved[:source], spell: slug, focus_max: focus_max(sheet), focus_points: focus_current(sheet) }
    end

  end
end
