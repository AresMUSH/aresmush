module AresMUSH    
	module Swrifts
		class ChargenpointsTemplate < ErbTemplateRenderer
			attr_accessor :char
  
			def initialize(char)
				@char = char
				super File.dirname(__FILE__) + "/chargenpoints.erb"
			end

			def chargenpoints
				format_three_per_line @char.swrifts_chargenpoints
			end

			def counters
				format_three_per_line @char.swrifts_counters
			end
			
			def randnum
				format_three_per_line @char.swrifts_randnum
			end

			def format_three_per_line(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 3 == 0 ? "\n" : ""
						title = left("#{ a.name }".capitalize, 16,'.')
						rating = left(a.rating, 7)
						"#{linebreak} #{title} #{rating} "
				end
			end
	
			
 		end
	end
end