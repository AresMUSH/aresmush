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
# Sheet Attribute Section

# --------------------------------------------
      def attrs
       list = []
        @char.console_attributes.sort_by(:name, :order => "ALPHA").each_with_index do |a, i|
          list << format_attr_learn(a, i)
        end
        list
      end

      def format_attr_learn(a, i)
        name = "%xh#{a.name}:%xn"
        linebreak = "%r"
        lb2 = i == 0 ? "" : "#{linebreak}"
        lp = "#{a.learnpoints}"
        lpn = SuperConsole.get_max_learn_adj(@char,a.name)
        canlearn = a.learnable ? "%xg+%xn" : "%xr-%xn"
        rating = "#{a.rating}"
        "#{lb2}[#{canlearn}] #{left(name, 34)} #{right(rating,3)} #{lp}/#{lpn}"
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
