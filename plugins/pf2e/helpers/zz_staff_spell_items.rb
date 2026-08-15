module AresMUSH
  module Pf2e

    # Extends staff_set for spell-item grants (loads after zz_staff_focus).

    class << self
      unless method_defined?(:staff_set_without_spell_items)
        alias_method :staff_set_without_spell_items, :staff_set
      end
    end

    def self.staff_set(enactor, char_name, field_path)
      blocked = staff_require_permission(enactor)
      return blocked if blocked

      result = staff_ensure_sheet(char_name)
      return result unless result[:ok]

      sheet = result[:sheet]
      char = result[:char]
      raw_parts = field_path.to_s.strip.split("/").map { |p| p.strip }.reject(&:empty?)
      parts = raw_parts.map { |p| p.downcase }
      return staff_set_without_spell_items(enactor, char_name, field_path) if parts.empty?

      # item/scroll/<spell>/<rank>/[tradition]
      # item/wand/<spell>/<rank>/[tradition]/[charges_max]
      # item/staff/<name_token>/[tradition]/[charges_max]  then optional spell=slug:rank:cost pairs not in path — use catalog preferred
      # item/spell/<catalog_slug>   grant from items.yml
      if parts[0] == "item" && %w[scroll wand staff spell].include?(parts[1].to_s)
        return staff_grant_spell_item(char, sheet, parts, raw_parts)
      end

      staff_set_without_spell_items(enactor, char_name, field_path)
    end

    def self.staff_grant_spell_item(char, sheet, parts, raw_parts)
      mode = parts[1].to_s

      if mode == "spell"
        slug = parts[2]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if slug.nil?
        r = inventory_add_from_catalog(sheet, slug, qty: 1, society: true)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        item = r[:item]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "spell-item +#{item_display_name(item)} (#{item['id']}) [Society]" }
      elsif mode == "scroll"
        spell = parts[2]
        rank = parts[3] ? parts[3].to_i : nil
        tradition = parts[4]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if spell.nil?
        r = inventory_add_spell_item(sheet, type: "scroll", spell: spell, rank: rank,
                                     tradition: tradition, society: true)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        item = r[:item]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "scroll +#{item_display_name(item)} (#{item['id']})" }
      elsif mode == "wand"
        spell = parts[2]
        rank = parts[3] ? parts[3].to_i : nil
        tradition = parts[4]
        charges_max = parts[5] ? parts[5].to_i : 1
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if spell.nil?
        r = inventory_add_spell_item(sheet, type: "wand", spell: spell, rank: rank,
                                     tradition: tradition, charges_max: charges_max,
                                     society: true)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        item = r[:item]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "wand +#{item_display_name(item)} (#{item['id']})" }
      elsif mode == "staff"
        # item/staff/<label>/<tradition>/<charges_max>/<spell>:<rank>[:cost]/...
        label = raw_parts[2]
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if label.nil?
        tradition = nil
        charges_max = 5
        spell_rows = []
        cantrips = []
        rest = parts[3..-1] || []
        rest.each do |tok|
          if %w[arcane divine occult primal].include?(tok)
            tradition = tok
          elsif tok =~ /^\d+$/
            charges_max = tok.to_i
          elsif tok.start_with?("cantrip:")
            cantrips << tok.sub(/^cantrip:/, "")
          elsif tok.include?(":")
            bits = tok.split(":")
            slug = bits[0]
            rank = (bits[1] || 1).to_i
            cost = (bits[2] || rank).to_i
            spell_rows << { "slug" => slug, "rank" => rank, "cost" => cost }
          end
        end
        name = label.to_s.tr("_", " ")
        r = inventory_add_spell_item(sheet, type: "staff", spell: spell_rows.first && spell_rows.first["slug"],
                                     rank: spell_rows.first && spell_rows.first["rank"],
                                     tradition: tradition, charges_max: charges_max,
                                     cantrips: cantrips, spells: spell_rows,
                                     name: name.start_with?("Staff") ? name : "Staff of #{name}",
                                     society: true)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        item = r[:item]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "staff +#{item_display_name(item)} (#{item['id']})" }
      else
        { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet }
      end
    end

  end
end
