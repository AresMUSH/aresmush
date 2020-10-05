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

			def ppe_max
				pmax = "ppe_max"
				return_counter pmax
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
			
			def return_counter(countername)
			countername = countername.downcase
			swriftscounters = @char.swrifts_counters
			swriftscounters.to_a.sort_by { |a| a.name }
				.each_with_index
					.map do |a, i| 
					if a.name.downcase == "#{countername}"
						return a.rating
					end
				end	
			end			
			
 		end
	end
end