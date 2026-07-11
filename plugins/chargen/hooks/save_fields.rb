module AresMUSH
  module Chargen
    module Hooks
      
      # Saves fields from character creation (chargen).
      #
      # @param [Character] char - The character being updated.
      # @param [Hash] chargen_data - A hash of character fields and values. Your custom fields
      #    will be in chargen_data['custom']. Multi-line text strings should be formatted for MUSH.
      #
      # @return [Array] - A list of error messages. Return an empty array ([]) if there are no errors.
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.save_fields(char, chargen_data)
        return []
      end
    end
  end
end