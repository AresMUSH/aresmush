module AresMUSH    
	module Swrifts
		class IconicfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name, :iconicf_title
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.iconicf_title = "iconicf"
			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end
			
			#----- Check to see if what was entered was an Iconic Framework in game\config\swrifts_iconicf.yml
			def check_valid_iconicf
				return t('swrifts.iconicf_invalid_name', :name => self.iconicf_name.capitalize) if !Swrifts.is_valid_iconicf_name?(self.iconicf_name)
				return nil
			end
#----- Begin of def handle -----			
			def handle  
			
				iconicf = Swrifts.get_iconicf(self.enactor, self.iconicf_name) 
				iconicf_stats=iconicf['stats']  
				iconicf_skills=iconicf['skills'] 

				## ----- Update Iconic Framework
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					trait = Swrifts.find_traits(model, self.iconicf_title)				
					trait.update(rating: self.iconicf_name)
				end
				client.emit_success ("Iconic Framework Added")

				## ----- Update Stats
				if (iconicf_stats)
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					iconicf_stats.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						stat_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the stat
						current_rating = Swrifts.stat_rating(enactor, stat_name)
						# add Iconic Framework bonus to Initial stat
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							stat = Swrifts.find_stat(model, stat_name)				
							stat.update(rating: new_rating)
						end
					end
					client.emit_success t('swrifts.iconicstats_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					client.emit_failure ("This Iconic Framework has no Stats")
				end

				## ----- Update Skills
				if (iconicf_skills)
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					iconicf_skills.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						skill_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the skill
						current_rating = Swrifts.skill_rating.to_i(enactor, skill_name)
						# add Iconic Framework bonus to Initial skill
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							skill = Swrifts.find_skill(model, skill_name)				
							skill.update(rating: new_rating)
						end
					end
					client.emit_success t('swrifts.iconicskills_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					client.emit_failure ("This Iconic Framework has no Skills")
				end


			end
#----- End of def handle -----	

		end
    end
end