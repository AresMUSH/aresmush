module AresMUSH    
	module Swrifts
		class HJSetCmd
			include CommandHandler
			      
			attr_accessor :target_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.hj_table = trim_arg(cmd.args) #Set 'hj_table' to be the inputted HJ

			end

			def required_args
				[ self.target_name, self.hj_table ]
			end
			
			
			#----- Check to see:
			def check_valid_hj_table
				if !Swrifts.is_valid_element_name?(self.hj_table) #Is the HJ on the IcF's list
					return t('swrifts.hj_table_invalid_name', :name => self.hj_table.capitalize) 
				else
					client.emit.failure ("That is not a valid table for your Iconic Framework.")
				end
			# end
			
#----- Begin of def handle -----			
			def handle  
				
				end
		
				client.emit_success t('swrifts.hjselect_complete')
			end
#----- End of def handle -----	

		end
    end
end