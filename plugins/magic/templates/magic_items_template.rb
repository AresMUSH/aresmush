module AresMUSH
  module Magic
    class MagicItemsTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/magic_items.erb"
      end

      def magic_items
        list = []
        @char.magic_items.each.each do |item|
          list << format_items(item)
        end
        list
      end

      def format_items(item)
        name = item
        desc = Magic.item_desc(item)
        "#{name}%r#{desc}%r"
      end

      def equipped_item
        if @char.magic_item_equipped
          @char.magic_item_equipped
        else
          "None"
        end
      end

      def potions_has
        format_two_per_line @char.potions_has
      end

      def length
        if equipped_item
          equipped_item.length
        else
          0
        end
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
