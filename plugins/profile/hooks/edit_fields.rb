module AresMUSH
  module Profile
    module Hooks
      # Gets custom fields for the character profile editor.
      #
      # @param [Character] char - The character being requested.
      # @param [Character] viewer - The character editing the profile.
      #
      # @return [Hash] - A hash containing custom fields and values. 
      #    Multi-line text strings must be formatted for editing.
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.edit_fields(char, viewer)
        return {}
      end
    end
  end
end