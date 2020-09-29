module AresMUSH
	module Swrifts
		class StatsSetCmd
			include CommandHandler
			  
			attr_accessor :target_name, :stat_name, :mod, :points_name
			
			#command syntax: swrifts/stat	<stat_name>=<new_rating>

			def parse_args
				args = cmd.parse_args(ArgParser.arg1_equals_arg2) #break <args> into arg1 and arg2
			    self.target_name = enactor_name #set target to enactor
			    self.stat_name = titlecase_arg(args.arg1) #set stat_name to arg1
			    self.mod = integer_arg(args.arg2) #set raing to arg2
				self.points_name = "stats_points"
			end

			def required_args
				[self.target_name, self.stat_name, self.mod]
			end
			
			def check_valid_stat
				return t('swrifts.invalid_stat_name') if !Swrifts.is_valid_stat_name?(self.stat_name)
				return nil
			end
			
			def check_stats_points
				current_stats_points = Swrifts.point_rating(enactor, self.points_name)
				if mod > current_stats_points
					return t('swrifts.invalid_points')
				else
					return nil
				end
			end
			  
			def handle
				current_rating = Swrifts.stat_rating(enactor, self.stat_name)
				client.emit ( current_rating )
				mod = self.mod
				client.emit ( mod )
				new_rating = current_rating + mod
				client.emit ( new_rating )

				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					stat = Swrifts.find_stat(model, self.stat_name)				
					stat.update(rating: new_rating)
				end

			end
		end
	end
end
