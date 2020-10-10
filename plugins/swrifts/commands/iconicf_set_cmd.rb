module AresMUSH    
	module Swrifts
		class IconicfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name, :iconicf_title, :init
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.iconicf_title = "iconicf"
				self.init = init
			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end
			
			
			#----- Check to see:
			# def check_valid_iconicf
				# if !Swrifts.is_valid_iconicf_name?(self.iconicf_name) #Is the Iconic Framework in the list
					# return t('swrifts.iconicf_invalid_name', :name => self.iconicf_name.capitalize) 
				# else
					# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						# if !Swrifts.is_valid_cat?(model,"traits") #Are there any traits set - i.e INIT completed.
							# return t('swrifts.iconicf_invalid_init', :name => "Traits")
						# elsif Swrifts.trait_set?(model,"iconicf") #Is the iconic framework already set
							# return t('swrifts.trait_already_set',:name => "Iconic Framework")
						# end
					# end
				# end
				# return nil
			# end
			
#----- Begin of def handle -----			
			def handle  
				enactor.delete_swrifts_chargen #clear out the character
			
				iconicf = Swrifts.get_iconicf(self.enactor, self.iconicf_name) 
				init = Global.read_config('swrifts', 'init')
				
				
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					Swrifts.run_init(model, init)
					trait = Swrifts.find_traits(model, self.iconicf_title)				
					client.emit ( "#{trait}" )
					trait.update(rating: iconicf_name)
					client.emit ( "#{trait}" )
					Swrifts.run_iconicf(model, iconicf)
				end

				
				client.emit_success t('swrifts.iconicf_complete')
			end
#----- End of def handle -----	

		end
    end
end