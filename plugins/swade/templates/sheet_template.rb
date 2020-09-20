module AresMUSH    
  module Swade
    class SheetTemplate < ErbTemplateRenderer
      attr_accessor :char
  
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def summary
        summ = @char.SwadeIconicf
      end
  
      def attrs
        format_two_per_line @char.Swade_attributes
      end
      
      def format_two_per_line(list)
        list.to_a.sort_by { |a| a.name }
          .each_with_index
            .map do |a, i| 
              linebreak = i % 2 == 0 ? "\n" : ""
              title = left("#{ a.name }:", 15)
              step = left(a.die_step, 20)
              "#{linebreak}%xh#{title}%xn #{step}"
        end
      end

    end
  end
end