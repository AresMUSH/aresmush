module AresMUSH
  module Pf2e

    # Loaded last (zz_*) so these replace the provisional magic.rb implementations.

    def self.magic_daily_reset(char_or_sheet, restore_focus: true)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      magic = magic_hash(sheet).dup
      magic.each do |src, entry|
        next unless entry.is_a?(Hash)
        next if src.to_s == "innate" || entry["casting"].to_s.downcase == "innate"
        e = entry.dup
        slots = (e["slots"] || {}).dup
        slots.each do |rank, slot|
          next unless slot.is_a?(Hash)
          s = slot.dup
          s["used"] = 0
          slots[rank] = s
        end
        e["slots"] = slots
        magic[src] = e
      end
      sheet.update(magic: magic)

      innate_daily_reset!(sheet)

      focus_result = nil
      if restore_focus
        focus_result = restore_focus_to_max!(sheet)
      end

      {
        ok: true,
        sources: magic_sources(sheet),
        focus_points: focus_current(sheet),
        focus_max: focus_max(sheet),
        focus: focus_result
      }
    end

    def self.magic_focus_max(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet
      ensure_focus_pool_from_spells!(sheet)
      focus_max(sheet)
    end

    def self.format_magic_status(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return t('pf2e.no_sheet') unless sheet

      sources = magic_sources(sheet)
      lines = []
      lines << "%xhSpellcasting%xn  Focus points: #{focus_current(sheet)} / #{focus_max(sheet)}"
      if sources.empty?
        lines << "  (no spellcasting sources)"
        return lines.join("%r")
      end

      sources.each do |src|
        entry = magic_source(sheet, src)
        next unless entry
        if src == "innate" || entry["casting"].to_s.downcase == "innate"
          lines.concat format_innate_lines(sheet)
          next
        end

        dc_info = magic_spell_dc(sheet, src)
        atk_info = magic_spell_attack_mod(sheet, src)
        dc = dc_info[:ok] ? dc_info[:value] : "?"
        atk = atk_info[:ok] ? atk_info[:value] : "?"
        trad = entry["tradition"] || "-"
        cast = entry["casting"] || "-"
        abil = (entry["attribute"] || entry["ability"] || "?").to_s.upcase
        rank = entry["proficiency"] || "T"
        cmax = entry["cantrips_max"].to_i

        lines << "%xh#{src}%xn  #{trad}/#{cast}  #{abil} #{rank}  DC #{dc}  Attack +#{atk}"

        slots = entry["slots"] || {}
        if slots.any?
          slot_bits = slots.keys.sort_by(&:to_i).map do |r|
            s = slots[r]
            s.is_a?(Hash) ? "R#{r} #{s['used'].to_i}/#{s['max'].to_i}" : "R#{r}"
          end
          lines << "  Slots: #{slot_bits.join(', ')}"
        end

        cantrips = Array(entry["cantrips"])
        c_label = cmax > 0 ? "#{cantrips.size}/#{cmax}" : cantrips.size.to_s
        lines << "  Cantrips (#{c_label}): #{cantrips.empty? ? '-' : cantrips.join(', ')}"

        prepared = entry["prepared"] || {}
        if prepared.any?
          prepared.keys.sort_by { |k| k.to_s == 'cantrip' ? 0 : k.to_i }.each do |r|
            list = Array(prepared[r])
            next if list.empty?
            label = r.to_s == 'cantrip' ? 'Cantrip prep' : "Rank #{r} prep"
            lines << "  #{label}: #{list.join(', ')}"
          end
        end

        rep = entry["repertoire"] || {}
        if rep.any?
          rep.keys.sort_by(&:to_i).each do |r|
            list = Array(rep[r])
            next if list.empty?
            lines << "  Repertoire R#{r}: #{list.join(', ')}"
          end
        end

        book = Array(entry["spellbook"])
        lines << "  Spellbook: #{book.join(', ')}" if book.any?

        focus = Array(entry["focus_spells"])
        lines << "  Focus spells: #{focus.join(', ')}" if focus.any?
      end

      if sources.size > 1
        lines << "%xhNote:%xn Multiple sources - use spell_dc:<source> / spell_attack:<source> when rolling."
      end

      lines.join("%r")
    end

  end
end
