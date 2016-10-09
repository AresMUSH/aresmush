module AresMUSH
  class Character
    attribute :utils_edit_prefix
    attribute :utils_saved_text, DataType::Array
    
    before_create :set_default_util_attributes
    
    def set_default_util_attributes
      self.utils_edit_prefix = "FugueEdit >"
    end
  end
end