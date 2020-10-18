module AresMUSH
	module Swrifts
		class SkillsSetCmd
			include CommandHandler
			  
			attr_accessor :target, :skill_name, :mod, :points_name
			
			#command syntax: swrifts/skills	<skill_name>=<new_rating>

			def parse_args
				args = cmd.parse_args(ArgParser.arg1_equals_arg2) #break <args> into arg1 and arg2
			    self.target = enactor_name #set target to enactor
			    self.skill_name = titlecase_arg(args.arg1) #set skill_name to arg1
			    self.mod = integer_arg(args.arg2) #set raing to arg2
				self.points_name = "skills_points"
			end

			def required_args
				[self.target, self.skill_name, self.mod]
			end
			
			def check_valid_stat
				return t('swrifts.invalid_skill_name') if !Swrifts.is_valid_skill_name?(self.skill_name)
				return nil
			end
			
			def check_stats_points #move this out to check before command runs
				current_skills_points = Swrifts.point_rating(enactor, self.points_name)
				if mod > current_skills_points
					return t('swrifts.invalid_points' , :name => self.skill_name, :num => current_skills_points, :mod => self.mod)
				else
					return nil
				end
			end
			  
			def handle
				current_rating = Swrifts.skill_rating(enactor, self.skill_name)
				client.emit (current_rating)
				mod = self.mod
				client.emit (mod)
				new_rating = current_rating + mod
				client.emit (new_rating)
				current_points = Swrifts.point_rating(enactor, self.points_name)
				client.emit (current_points)
				new_points = current_points - mod
				client.emit (new_points)

				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					stat = Swrifts.find_skill(model, self.skill_name)				
					stat.update(rating: new_rating)
				end
				
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					points = Swrifts.find_points(model, self.points_name)	
					client.emit (points)
					points.update(rating: new_points)
				end
				
				client.emit_success t('swrifts.points_spend' , :name => self.skill_name, :mod => self.mod)
			end
		end
	end
end
