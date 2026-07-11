module AresMUSH
  module Chargen
    module Hooks
      # Gets custom fields for character creation (chargen).
      #
      # @param [Character] char - The character being requested.
      #
      # @return [Hash] - A hash containing custom fields and values. 
      #    Multi-line text strings must be formatted for editing.
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.edit_fields(char)
        return {}
      end
    end
  end
end