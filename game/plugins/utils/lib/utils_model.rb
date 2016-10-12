module AresMUSH
  class Character
    attribute :utils_edit_prefix
    attribute :utils_saved_text, DataType::Array
    
    default_values :default_util_attributes
    
    def self.default_util_attributes
      { utils_edit_prefix: "FugueEdit >" }
    end
  end
end