module AresMUSH    
	module Swrifts
		class SheetTemplate < ErbTemplateRenderer
			attr_accessor :char
  
			def initialize(char)
				@char = char
				super File.dirname(__FILE__) + "/sheet.erb"
			end

			def iconicf_name
				@char.swrifts_iconicf
			end

			def stats
				format_stats @char.swrifts_stats
			end

			def skills
				format_three_per_line @char.swrifts_skills
			end
			
			def hinderances
				format_two_column @char.swrifts_hinderances
			end

			def edges
				format_two_column @char.swrifts_edges
			end
			
			def abilities
				format_two_column @char.swrifts_abilities
			end

			def complications
				format_two_column @char.swrifts_complications
			end

			def mpowers
				format_two_column @char.swrifts_mpowers
			end
			
			def counters
				format_three_per_line @char.swrifts_counters
			end

			def counterscurrent
				aclcounters = @char.swrifts_counters
				aclcountclass = aclcounters.class
				aclcounters.to_a.sort_by { |a| a.name }
				aclnewarray = aclcounters.select { |a| a['name'].downcase == "bennies_current" }
				return aclnewarray
					.each_with_index
						.map do |a, i| 
						linebreak = "\n"
						if a.name.downcase == "bennies_current"
							title = left("#{ a.name }".capitalize, 16,'.')
							rating = left(a.rating, 7)
						else
							title = "nothing found"
							rating = 000
						end
						"#{aclcountclass} "
				end		
			end
			
			# def format_counters
				# counters_raw = @char.swrifts_counters
				# result = counters_raw.find { |item| item.include?("bennies")}
				# "#{result}"
			# end
		
			def format_stats(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 5 == 0 ? "\n" : ""
						title = right("#{ a.name }:".capitalize, 10)
						rating = left(a.rating, 5)
						"#{linebreak}#{title} #{rating}"
				end
			end
      
			def format_two_per_line(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 2 == 0 ? "\n" : ""
						title = left("#{ a.name }:", 15)
						rating = left(a.rating, 20)
						"#{linebreak} #{title} #{rating}"
				end
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

			def format_two_column(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 2 == 0 ? "\n" : ""
						title = left("#{ a.name }".capitalize, 39)
						"#{linebreak} #{title}"
				end
			end

			def format_three_column(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 3 == 0 ? "\n" : ""
						title = left("#{ a.name }".capitalize, 25)
						"#{linebreak} #{title}"
				end
			end
		
		end
	end
end