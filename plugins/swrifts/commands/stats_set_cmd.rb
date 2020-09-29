module AresMUSH
	module Swrifts
		class StatsSetCmd
			include CommandHandler
			  
			attr_accessor :target_name, :stat_name, :rating
			
			#command syntax: swrifts/stat	<stat_name>=<new_rating>

			def parse_args
				args = cmd.parse_args(ArgParser.arg1_equals_arg2) #break <args> into arg1 and arg2
			    self.target_name = enactor_name #set target to enactor
			    self.stat_name = titlecase_arg(args.arg1) #set stat_name to arg1
			    self.rating = downcase_arg(args.arg2) #set raing to arg2
			end

			def required_args
				[self.target_name, self.ability_name, self.rating]
			end
			
			def check_valid_stat
				return t('swrifts.invalid_stat_name') if !Swrifts.is_valid_stat_name?(self.stat_name)
				return nil
			end			
			  
			# def stat_current
				# stat = "stat_current"
				# return_current_stat stat
			# end
			
			# add check for stat cap max
			
			# def return_current_stat(statname)
			# statname = traitname.downcase
			# swriftsstats = @char.swrifts_stats
			# swriftsstats.to_a.sort_by { |a| a.name }
				# .each_with_index
					# .map do |a, i| 
					# if a.name.downcase == "#{statname}"
						# return a.rating
					# end
				# end	
			# end
			  
			def handle
				current_rating = Swrifts.stat_rating(enactor, self.name)
				client.emit ( current_rating )
				mod = self.rating
				client.emit ( mod )
				new_rating = current_rating + mod
				client.emit ( new_rating )

				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					stat = Swrifts.find_stat(model, self.stat_name)				
					stat.update(rating: new.rating)
				end
				
				
				# error = Swrifts.check_rating(self.name, new_rating)
				# if (error)
				  # client.emit_failure error
				  # return
				# end
			  
				# error = Swrifts.set_stat(enactor, self.name, new_rating)
				# if (error)
				  # client.emit_failure error
				# else
				  # client.emit_success Swrifts.stat_raised_text(enactor, self.name)
				# end
			end
		end
	end
end
