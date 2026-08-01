module AresMUSH
  module AltTracker
    class AltStatusTemplate < ErbTemplateRenderer

      attr_accessor :email, :banned, :characters, :current_char

      def initialize(data, current_char)
        @email = data[:email]
        @banned = data[:banned]
        @characters = data[:characters]
        @current_char = current_char
        super File.dirname(__FILE__) + "/alt_status.erb"
      end

      def banned_display
        banned ? "%xrYES%xn" : "%xgNo%xn"
      end

      def total_alts
        characters.size
      end

      def char_line(char)
        marker = (char == current_char) ? " %xh(you)%xn" : ""
        "  #{char.name}#{marker}"
      end
    end
  end
end
