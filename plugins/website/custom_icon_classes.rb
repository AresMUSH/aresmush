module AresMUSH
  module Website
    module Hooks
      
      # Gets custom classes to add to the big character log icons.
      #
      # @param [Character] char - The character being requested.
      # @param [Character] viewer - The character viewing the profile. May be nil if someone is viewing
      #    the profile without being logged in.
      #
      # @return [string] - A list of CSS classes to include on the icon div.
      
      def self.custom_icon_classes(char, viewer)
        return ""
      end

    end
  end
end