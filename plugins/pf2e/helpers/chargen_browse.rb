module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Browse helpers — available identity options
    # Returns arrays of { slug:, name:, note: } for CLI/web.
    # -------------------------------------------------

    def self.cg_list_ancestries
      data = read_data("ancestries") || {}
      data.keys.sort.map do |slug|
        entry = data[slug] || {}
        {
          slug: slug.to_s,
          name: entry["name"] || slug.to_s,
          note: "HP #{entry["hp"]} · Spd #{entry["speed"]}"
        }
      end
    end

    # If sheet has an ancestry, only heritages listed on that ancestry.
    # Otherwise list all heritages with their parent ancestry note.
    def self.cg_list_heritages(char = nil)
      sheet = char ? (cg_ensure_sheet(char)[:sheet] rescue nil) : nil
      heritages = read_data("heritages") || {}

      if sheet && !sheet.ancestry.blank?
        anc = cg_ancestry_entry(sheet.ancestry)
        allowed = Array(anc && anc["heritages"]).map(&:to_s)
        return allowed.sort.map do |slug|
          entry = heritages[slug] || {}
          {
            slug: slug,
            name: entry["name"] || slug,
            note: sheet.ancestry.to_s
          }
        end
      end

      heritages.keys.sort.map do |slug|
        entry = heritages[slug] || {}
        {
          slug: slug.to_s,
          name: entry["name"] || slug.to_s,
          note: entry["ancestry"].to_s
        }
      end
    end

    def self.cg_list_backgrounds
      data = read_data("backgrounds") || {}
      data.keys.sort.map do |slug|
        entry = data[slug] || {}
        choices = Array(entry["skill_choices"]).size
        note_parts = []
        note_parts << "#{choices} choice(s)" if choices > 0
        feat = entry["feat"].to_s
        note_parts << "feat: #{feat}" if !feat.empty? && feat != "null"
        {
          slug: slug.to_s,
          name: entry["name"] || slug.to_s,
          note: note_parts.join(" · ")
        }
      end
    end

    def self.cg_list_classes
      data = read_data("charclasses") || {}
      data.keys.sort.map do |slug|
        entry = data[slug] || {}
        keys = Array((entry["key_ability"] || {})["options"]).map(&:to_s)
        {
          slug: slug.to_s,
          name: entry["name"] || slug.to_s,
          note: keys.empty? ? "HP #{entry["hp"]}" : "key: #{keys.join("/")} · HP #{entry["hp"]}"
        }
      end
    end

    def self.cg_format_option_list(title, rows)
      return "#{title}\n  (none in data)" if rows.nil? || rows.empty?
      lines = [title]
      rows.each do |row|
        note = row[:note].to_s
        if note.empty?
          lines << "  #{row[:slug]} — #{row[:name]}"
        else
          lines << "  #{row[:slug]} — #{row[:name]} (#{note})"
        end
      end
      lines.join("\n")
    end

  end
end
