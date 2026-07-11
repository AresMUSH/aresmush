module AresMUSH
  module Profile
    module Hooks
      # Saves fields from profile editing.
      #
      # @param [Character] char - The character being updated.
      # @param [Character] enactor - The character triggering the update.
      # @param [Hash] char_data - A hash of character fields and values. Your custom fields
      #    will be in char_data['custom']. Multi-line text strings should be formatted for MUSH.
      #
      # @return [Array] - A list of error messages. Return an empty array ([]) if there are no errors.
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.save_fields(char, enactor, char_data)
        return []
      end
    end
  end
end