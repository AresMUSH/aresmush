module AresMUSH
  module Profile
    class CustomCharFields
      
      # Note: Viewer may be nil if someone's looking at the character page without being logged in
      def self.get_fields_for_viewing(char, viewer)
      end
    
      def self.get_fields_for_editing(char, viewer)
      end

      def self.get_fields_for_chargen(char)
      end
      
      def self.save_fields_from_profile_edit(char, viewer, char_data)
      end
      
      def self.save_fields_from_chargen(char, chargen_data)
        
        # Return an array of any error messages.
        []
      end
      
    end
  end
end