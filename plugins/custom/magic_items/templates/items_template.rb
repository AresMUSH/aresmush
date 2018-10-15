module AresMUSH
  module Custom
    class MagicItemsTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/magic_items.erb"
      end

      def magic_items
        @char.magic_items
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




    end
  end
end
