module AresMUSH    
	module Swrifts
		class SheetTemplate < ErbTemplateRenderer
			attr_accessor :char
  
			def initialize(char)
				@char = char
				super File.dirname(__FILE__) + "/sheet.erb"
			end

			def ifforsheet
				traitname = "iconicf"
				return_traits(traitname)
			end
			
			def raceforsheet
				traitname = "race"
				return_traits(traitname)
			end
			
			def rankforsheet
				traitname = "rank"
				return_traits(traitname)
			end
			
			def benniescount
				bc = "bennies_current"
				return_counter bc
			end

			def convictioncount
				cc = "conviction_current"
				return_counter cc
			end
			
			def damageforsheet
				dmg = "damage"
				return_counter dmg
			end

			def stats
				format_stats @char.swrifts_stats
			end

			def dstats
				format_three_per_line @char.swrifts_dstats
			end

			def skills
				format_three_per_line @char.swrifts_skills
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
			
			def format_three_per_line(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 3 == 0 ? "\n" : ""
						title = left("#{ a.name }".capitalize, 18,'.')
						die_rating = Swrifts.rating_to_die(a.rating)
						rating = left(die_rating, 5)
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