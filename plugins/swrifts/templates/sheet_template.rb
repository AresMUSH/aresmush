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
			
			def race_name
				@char.swrifts_race
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
			
			def benniescount
				bc = "bennies_current"
				return_counter bc
			end

			def convictioncount
				cc = "conviction_current"
				return_counter cc
			end

			def rankforsheet
				rank = "rank"
				return_traits(rank)
			end
			
			def damageforsheet
				dmg = "damage"
				return_counter dmg
			end
		
			def format_stats(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 5 == 0 ? "\n" : ""
						title = right("#{ a.name }:".capitalize, 10)
						die_rating = Swrifts.rating_to_die(a.rating)
						rating = left(die_rating, 5)
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
						die_rating = Swrifts.rating_to_die(a.rating)
						rating = left(die_rating, 7)
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
			
			def return_traits(traitname)
			traitname = traitname.downcase
			swriftstraits = @char.swrifts_traits
			txtstring = ''
			swriftstraits.to_a.sort_by { |a| a.name }
				.each_with_index
					.map do |a, i| 
					if a.name.downcase == "#{traitname}"
						return ("#{a.rating}")	
					end
				end	
				
			end

		end
	end
end