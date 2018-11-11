module AresMUSH
  class Character
    attribute :utils_edit_prefix, :default => "FugueEdit >"
    attribute :utils_saved_text, :type => DataType::Array
    attribute :notes, :type => DataType::Hash, :default => {}
    attribute :ascii_mode_enabled, :type => DataType::Boolean, :default => false
    
    def notes_section(section)
      self.notes[section] || {}
    end
    
    def update_notes_section(section, notes)
      all_notes = self.notes || {}
      all_notes[section] = notes
      self.update(notes: all_notes)
    end
  end
end