module AresMUSH
  class Character
    attribute :prefs, :type => DataType::Hash, :default => {}
    attribute :prefs_notes
  end
end