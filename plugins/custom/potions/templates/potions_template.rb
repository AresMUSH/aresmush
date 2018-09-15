module AresMUSH
  module Custom
    class PotionsTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/potions.erb"
      end

      def potions_has
        format_two_per_line @char.potions_has
      end


      def format_two_per_line(list)
        list.to_a.sort_by { |a| a.name }
          .each_with_index
            .map do |a, i|
              linebreak = i % 2 == 0 ? "\n" : ""
              title = left("#{ a.name }", 25)
              "#{linebreak}#{title} "
        end
      end

      def potions_creating
        @char.potions_creating.to_a
      end

      def time_to_creation
        potions_creating each_with_index do |a, index|
          hours = a.hours_to_creation
          return hours
        end
      end


    end
  end
end
