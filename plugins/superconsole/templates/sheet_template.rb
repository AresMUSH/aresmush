module AresMUSH
  module SuperConsole
    class SheetTemplate < ErbTemplateRenderer

      attr_accessor :char

      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end
# --------------------------------------------
# General Sheet Items
      def game_name
        Global.read_config("game","name")
      end
# --------------------------------------------

# --------------------------------------------
# Sheet Info Section


      def approval_status
        Chargen.approval_status(@char)
      end
      def char_class
        @char.group("class") || "Unknown"
      end
      def profession
        @char.group("profession") || "Unknown"
      end
      def race
        @char.group("race") || "Unknown"
      end
      def age
        age = @char.age
        age == 0 ? "--" : age
      end
      def level
        @char.console_level
      end
      def oversoul_type
        type = @char.console_oversoul_type
        if type == nil
          "Unknown"
        else
          type
        end
      end
      def guild
        "Unknown"
      end
      def level_cleared
        "0"
      end
# --------------------------------------------
# --------------------------------------------
# Sheet Attribute Section

# --------------------------------------------
      def attrs
       list = []
        @char.console_attributes.sort_by(:name, :order => "ALPHA").each_with_index do |a, i|
          list << format_attr(a, i)
        end
        list
      end

      def favor_status(a)
        if a.favored == true
          "+"
        elsif a.unfavored == true
          "-"
        else
          " "
        end
      end

      def format_attr(a, i)
        name = "%xh#{a.name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        spacebreak = i % 2 == 0 ? "  " : ""
        status = favor_status(a)
        rating = "#{a.rating}"
        "#{linebreak}[#{status}] #{left(name, 12)} #{right(rating,21)}#{spacebreak}"
      end

    end
  end
end
