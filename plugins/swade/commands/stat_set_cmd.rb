module AresMUSH    
  module Swade
    class AttributeSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :stat_name, :die_step, :acltest, :newacltest
 


      def parse_args
	  
        # Admin version
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3) #ArgParser is a function that splits a command string
          self.target_name = titlecase_arg(args.arg1) #Set the character to be updated from the command string
          self.stat_name = titlecase_arg(args.arg2) #set the stat name to be updated from the command string
          self.die_step = downcase_arg(args.arg3) #set the die_step to be updated from the command string
        # Self version 
		else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2) #ArgParser is a function that splits a command string
          self.target_name = enactor_name #Set the character to be the current character
          self.stat_name = titlecase_arg(args.arg1) #set the stat name to be updated from the command string
          self.die_step = downcase_arg(args.arg2) #set the die_step to be updated from the command string
        end
        self.die_step = Swade.format_die_step(self.die_step)
      end
      
      def required_args
        [self.target_name, self.stat_name, self.die_step]
      end
      
      def check_valid_die_step
        return nil if self.die_step == '0'
        return t('Swade.invalid_die_step', :die_step => self.die_step) if !Swade.is_valid_die_step?(self.die_step)
        return nil
      end
      
      def check_valid_stat
        return t('Swade.invalid_stat_name', :name => self.stat_name) if !Swade.is_valid_stat_name?(self.stat_name)
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.target_name
        return nil if Swade.can_manage_stats?(enactor)
        return t('dispatcher.not_allowed')
      end     
      
      def check_chargen_locked
        return nil if Swade.can_manage_stats?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def check_rating
        return nil if Swade.can_manage_stats?(enactor)
        Swadecheck_max_starting_rating(self.die_step, 'max_stat_step')
      end
      
      def handle
	  
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
          attr = Swade.find_stat(model, self.stat_name) #Calls the find stat function in /public/swade_model.rb and returns the HASHED record.
		  
          if (attr && self.die_step == '0')	#If the stat is set AND the die_step is 0 delete the stat in the character hash.		  
            attr.delete
            client.emit_success t('Swade.stat_removed', :name => self.stat_name)
            return
          end
		    
          if (attr) #If the stat is already set in the HASH then update it. 
            attr.update(die_step: self.die_step)
          else #If the stat is not already set in the HASH 
			if (self.die_step != '0') #If the stat is missing and DIE_STEP is NOT set to 0, then set it
				SwadeAttribute.create(name: self.stat_name, die_step: self.die_step, character: model)
			else #If the stat is missing and DIE_STEP is set to 0, then say it did nothing and just return.
				client.emit_success t('Swade.stat_not_set', :name => self.stat_name)  #Tell player the stat wasn't set 
				return
			end
          end

          client.emit_success t('Swade.stat_set', :name => self.stat_name, :rating => self.die_step) #Tell the player the stat was set. 
        end
      end
    end
  end
end