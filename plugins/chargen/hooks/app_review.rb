module AresMUSH
  module Chargen
    module Hooks
      # Generates custom messages for the chargen app review screen.
      #
      # @param [Character] char - The character being reviewed.
      #
      # @return [string] - A single string containing the app review
      #   text to display. You can combine multiple messages using
      #   %R, but it has to all be one string. If you have no custom
      #   app review, return nil
      # 
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.app_review(char)
        return nil
      end
    end
  end
end