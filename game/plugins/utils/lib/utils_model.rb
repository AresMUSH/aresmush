module AresMUSH
  class Character
    attribute :edit_prefix
    attribute :saved_text, DataType::Array
    
    before_create :set_default_util_attributes
    
    def set_default_util_attributes
      self.edit_prefix = "FugueEdit >"
    end
  end
end