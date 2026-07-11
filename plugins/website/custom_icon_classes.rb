module AresMUSH
  module Website
    module Hooks
      
      # Gets custom classes to add to the big character log icons.
      #
      # @param [Character] char - The character being requested.
      # @return [string] - A single string containing one or more CSS classes to include on the icon div.
      
      def self.custom_icon_classes(char)
        return ""
      end

    end
  end
end