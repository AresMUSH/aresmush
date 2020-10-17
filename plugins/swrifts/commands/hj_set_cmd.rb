module AresMUSH    
	module Swrifts
		class HJSetCmd
			include CommandHandler
			      
			attr_accessor :target_name
			
			#swrifts/hj 1=Body Armor
			
			def parse_args
			    args = cmd.parse_args(ArgParser.arg1_equals_arg2) #Split the arguments into two around the =
			    self.target_name = enactor_name #Set the character to be the current character
			    self.hj_slot = args.arg1 #set the hj slot
			    self.hj_table_name = trim_arg(args.arg2) #set the hj name
			end

			def required_args
				[ self.target_name, self.hj_slot, self.hj_table_name ]
			end
			
			
			#----- Check to see:
			def check_valid_hj_table
				
				client.emit (self.hj_slot)
				client.emit (self.hj_table_name)
				return
				
				if !Swrifts.is_valid_element_name?(self.hj_table_name) #Is the HJ on the IcF's list
					return t('swrifts.hj_table_invalid_name', :name => self.hj_table.capitalize) 
				else
					client.emit.failure ("That is not a valid table for your Iconic Framework.")
				end
			end
			
#----- Begin of def handle -----			
			def handle  
				
		
				client.emit_success t('swrifts.hjselect_complete')
			end
#----- End of def handle -----	

		end
    end
end