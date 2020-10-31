module AresMUSH    
	module Swrifts
		class Sheet2Template < ErbTemplateRenderer
			attr_accessor :char
  
			def initialize(char)
				@char = char
				super File.dirname(__FILE__) + "/sheet2.erb"
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
			
			def heroesj
				format_hj @char.swrifts_heroesj
			end
			
			def fandg
				format_hj @char.swrifts_fandg
			end

			def complications
				format_two_column @char.swrifts_complications
			end

			def mpowers
				format_two_column @char.swrifts_mpowers
			end

			def ppowers
				format_two_column @char.swrifts_ppowers
			end

			def cybernetics
				format_two_column @char.swrifts_cybernetics
			end
			
			#def advances
			#
			#end
			
			def format_two_column(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						linebreak = i % 2 == 0 ? "\n" : ""
						title = left("#{ a.name }".capitalize, 39)
						"#{linebreak} #{title}"
				end
			end

			def format_hj(list)
				list.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a | 
						title = "#{ a.name } -".capitalize
						table = "#{ a.table }".capitalize
						desc = "#{a.description}"
						"#{title} #{table}: #{desc}"
				end
			end

		end
	end
end