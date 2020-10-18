module AresMUSH
	module Swrifts
		class StatsSetCmd
			include CommandHandler
			  
			attr_accessor :target, :stat_name, :mod, :points_name
			
			#command syntax: swrifts/stat	<stat_name>=<new_rating>

			def parse_args
				args = cmd.parse_args(ArgParser.arg1_equals_arg2) #break <args> into arg1 and arg2
			    self.target = enactor_name #set target to enactor
			    self.stat_name = titlecase_arg(args.arg1) #set stat_name to arg1
			    self.mod = integer_arg(args.arg2) #set raing to arg2
				self.points_name = "stats_points"
			end

			def required_args
				[self.target, self.stat_name, self.mod]
			end
			
			def check_valid_stat
				return t('swrifts.invalid_stat_name') if !Swrifts.is_valid_stat_name?(self.stat_name)
				return nil
			end
			
			def check_stats_points #move this out to check before command runs
				current_stats_points = Swrifts.point_rating(enactor, self.points_name)
				if mod > current_stats_points
					return t('swrifts.invalid_points' , :name => self.stat_name, :num => current_stats_points, :mod => self.mod)
				else
					return nil
				end
			end
			  
			def handle
				current_rating = Swrifts.stat_rating(enactor, self.stat_name)
				mod = self.mod
				new_rating = current_rating + mod
				current_points = Swrifts.point_rating(enactor, self.points_name)
				client.emit (current_points)
				new_points = current_points - mod
				client.emit (new_points)

				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					stat = Swrifts.find_stat(model, self.stat_name)				
					stat.update(rating: new_rating)
				end
				
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					points = Swrifts.find_points(model, self.points_name)	
					client.emit (points)
					points.update(rating: new_points)
				end
				
				client.emit_success t('swrifts.points_spend' , :name => self.stat_name, :mod => self.mod)
			end
		end
	end
end
