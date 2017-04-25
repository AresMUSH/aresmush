module AresMUSH
  class Character
    attribute :utils_edit_prefix, :default => "FugueEdit >"
    attribute :utils_saved_text, :type => DataType::Array
    attribute :notes, :type => DataType::Hash
  end
end