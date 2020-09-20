module AresMUSH    
  module Swade
    class SheetTemplate < ErbTemplateRenderer
      attr_accessor :char
  
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def iconicf_name
		summ = @char.swade_iconicf
		#summ = "#{char.swade_iconicf_name}"
		summ
      end
  
      def attributes
        #format_two_per_line @char.swade_attributes
        @char.swade_attributes.to_a.sort_by { |a| a.name }
			.each_with_index
				.map do |a, i| 
					linebreak = i % 2 == 0 ? "\n" : ""
					title = left("#{ a.name }:", 15)
					rating = left(a.rating, 20)
					"#{linebreak}%xh#{title}%xn #{rating}"
			end
      end
      
      # def format_two_per_line(list)
		# puts ("kdkdkd")
        # list.to_a.sort_by { |a| a.name }
          # .each_with_index
            # .map do |a, i| 
              # linebreak = i % 2 == 0 ? "\n" : ""
              # title = left("#{ a.name }:", 15)
              # step = left(a.die_step, 20)
              # "#{linebreak}%xh#{title}%xn #{step}"
        # end
      # end

      # def format_two_per_line(list)
        # list.to_a.sort_by { |a| a.name }
          # .each_with_index
            # .map do |a, i| 
              # linebreak = i % 2 == 0 ? "\n" : ""
              # title = left("#{ a.name }:", 15)
              # rating = left(a.rating, 20)
              # "#{linebreak}%xh#{title}%xn #{rating}"
        # end
      # end

    end
  end
end