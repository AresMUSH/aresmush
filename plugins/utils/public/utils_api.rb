module AresMUSH
  module Utils
    def self.grab(client, char, msg)
      prefix = char.utils_edit_prefix ? "#{char.utils_edit_prefix} " : ""
      client.emit_raw "#{prefix}#{msg}"
    end
    
    def self.export_notes(char)
      section = "player"
      text = char.notes_section(section)
      title = t("notes.notes_#{section}_title", :name => char.name)
      template = BorderedDisplayTemplate.new text, title
      return template.render
    end
  end
end