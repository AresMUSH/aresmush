module AresMUSH
  module Profile
    module Hooks
      # Gets custom fields for display in a character profile.
      #
      # @param [Character] char - The character being requested.
      # @param [Character] viewer - The character viewing the profile. May be nil if someone is viewing
      #    the profile without being logged in.
      #
      # @return [Hash] - A hash containing custom fields and values. 
      #    Ansi or markdown text strings must be formatted for display.
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.view_fields(char, viewer)
        return {}
      end
    end
  end
end