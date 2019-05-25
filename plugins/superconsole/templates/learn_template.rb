module AresMUSH
  module SuperConsole
    class LearnTemplate < ErbTemplateRenderer

      attr_accessor :char

      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/learn.erb"
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
      def archetype
        @char.group("archetype") || "Unknown"
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

      def format_attr(a, i)
        name = "%xh#{a.name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        lb2 = i == 0 ? "" : "#{linebreak}"
        spacebreak = i % 2 == 0 ? "  " : ""
        rating = "#{a.rating}"
        "#{lb2}#{left(name, 34)} #{right(rating,3)}#{spacebreak}"
      end

      def abils_learned
       list = []
       stats = @char.console_skills.sort_by(:name, :order => "Alpha")
       filtered = stats.select{ |x,_| x.learned == true}
            filtered.each_with_index do |a, i|
            list << format_skill(a, i)
        end
              list
      end

      def abils_learning
       list = []
       stats = @char.console_skills.sort_by(:name, :order => "Alpha")
       filter = stats.select{ |x,_| x.learned == false}
       filtered = filter.select{ |x,_| x.learnpoints >= 1}
            filtered.each_with_index do |a, i|
            list << format_skill(a, i)
        end
              list
      end
      def format_skill(a, i)
        name = "%xh#{a.name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        lb2 = i == 0 ? "" : "#{linebreak}"
        spacebreak = i % 2 == 0 ? "  " : ""
        rating = "#{a.rating}"
        "#{lb2}#{left(name, 34)} #{right(rating,3)}#{spacebreak}"
      end
    end
  end
end
