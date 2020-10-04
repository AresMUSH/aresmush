module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework

			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end

			
			## ----- start of def handle
			def handle
				iconicf = Swrifts.get_iconicf(self.target_name, self.iconicf_name) 
				iconicf_hinderances=iconicf['hinderances'] 
				
				if (iconicf_hinderances) 
					iconicf_hinderances.each do |key|
						setthing = "#{key}".downcase
						Swrifts.add_hinderance(self.target_name, setthing)
						# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# SwriftsHinderances.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconichinderances_set')
				else 
					client.emit_failure ("This Iconic Framework has no Hinderances")
				end

			end
			## ----- end of def handle
			
		end
	end
end