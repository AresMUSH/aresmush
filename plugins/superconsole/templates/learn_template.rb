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
        lp = a.learnpoints
        lpn = SuperConsole.get_max_learn_adj(@char,a.name)
        percent = (lp/lpn) * 100
        canlearn = a.learnable ? "%xg+%xn" : "%xr-%xn"
        rating = "#{a.rating}"
        "[#{canlearn}] #{left(name, 34)} #{right(rating,3)} #{percent}% #{lp}/#{lpn}"
      end

      def abils_learning
       list = []
       @char.console_skills.sort_by(:name, :order => "Alpha").each_with_index do |a, i|
            list << format_skill_learn(a, i)
        end
        list
      end

      def format_skill_learn(a, i)
        name = "%xh#{a.name}:%xn"
        lp = a.learnpoints
        lpn = SuperConsole.get_max_learn_adj(@char,a.name)
        percent = (lp/lpn) * 100
        canlearn = a.learnable ? "%xg+%xn" : "%xr-%xn"
        rating = "#{a.rating}"
        "[#{canlearn}] #{left(name, 34)} #{right(rating,3)} #{percent}% #{lp}/#{lpn}"
      end
    end
  end
end
