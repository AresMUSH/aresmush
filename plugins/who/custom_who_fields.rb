module AresMUSH
  module Who
  
    def self.custom_who_field(char, field_type, value, width)
      # If you have custom who fields, you can do their parsing here and return a string value for 
      # display. field_type, value, and width come from the WHO config. You are expected to 
      # format the field to fit the available width.
      #
      # case field_type
      # when 'mycustomfield'
      #   return "Some Custom Data".ljust(width)
      # else
      #   return nil
      # end
        
      # NOTE! It is very important to return nil if it is NOT a custom field.
      return nil
    end 
  end
end