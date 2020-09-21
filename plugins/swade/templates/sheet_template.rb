module AresMUSH    
	module Swade
		class SheetTemplate < ErbTemplateRenderer
			attr_accessor :char
  
			def initialize(char)
				@char = char
				super File.dirname(__FILE__) + "/sheet.erb"
			end

			def iconicf_name
				@char.swade_iconicf
			end
  
			def stats
				format_stats @char.swade_stats
			end

			 def skills
				format_three_per_line @char.swade_skills
			 end
      
			def format_two_per_line(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 2 == 0 ? "\n" : ""
						title = left("#{ a.name }:", 15)
						rating = left(a.rating, 20)
						"#{linebreak}%xh#{title}%xn #{rating}"
				end
			end
			
			def format_three_per_line(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 3 == 0 ? "\n" : ""
						title = left("#{ a.name }:", 16)
						rating = left(a.rating, 7)
						"%b#{linebreak}%xh#{title}%xn #{rating} "
				end
			end

			def format_stats(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 5 == 0 ? "\n" : ""
						title = right("#{ a.name }:", 10)
						rating = left(a.rating, 5)
						"#{linebreak}%xh#{title}%xn #{rating}"
				end
			end
		
		end
	end
end