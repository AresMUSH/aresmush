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
          list << format_stat(a, i)
        end
        list
      end

      def abils_learning
       list = []
       @char.console_skills.sort_by(:name, :order => "Alpha").each_with_index do |a, i|
            list << format_stat(a, i)
        end
        list
      end

      def format_stat(a, i)
        name = "%xh#{a.name}:%xn"
        rating = "#{a.rating}"
        has_learned = a.learned ? "%xgk%xn" : "%xru%xn"
        if a.learnable
          lp = a.learnpoints
          lr = "#{lp}".length > 3 ? Custom.commify(lp) : lp
          lpn = SuperConsole.get_max_learn_adj(@char,"#{a.name}")
          lpp = "#{lpn}".length > 3 ? Custom.commify(lpn) : lpn
          percent = ((lp/lpn) * 100).floor
          canlearn = "%xg+%xn"
          learning = "#{percent}% #{lr}/#{lpp}"
        else
          canlearn = "%xr-%xn"
          learning = center(- "MAXED" -,20,-)
        end
        "[#{canlearn}] (#{has_learned}) #{left(name, 34)} #{right(rating,3)} #{learning}"
      end
    end
  end
end
