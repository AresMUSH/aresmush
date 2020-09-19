module AresMUSH    
  module Swade
    class AttributeSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :attribute_name, :die_step, :acltest, :newacltest
 


      def parse_args
	  
        # Admin version
        if (cmd.args =~ /\//)
  		  self.acltest = 'adminonly'
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3) #ArgParser looks to be a function
          self.target_name = titlecase_arg(args.arg1)
          self.attribute_name = titlecase_arg(args.arg2)
          self.die_step = downcase_arg(args.arg3)
        # Self version 
		else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2) #ArgParser looks to be a function
          self.target_name = enactor_name
          self.attribute_name = titlecase_arg(args.arg1)
  		  self.acltest = "self Enactor: #{enactor_name} Attr: #{attribute_name} Arg1: #{args.arg1} Arg2: #{args.arg2} Target: #{target_name}"  #Setting a string to set the attribute acltest.
          self.die_step = downcase_arg(args.arg2)
        end
        self.die_step = Swade.format_die_step(self.die_step)
      end
      
      def required_args
        [self.target_name, self.attribute_name, self.die_step]
      end
      
      def check_valid_die_step
        return nil if self.die_step == '0'
        return t('Swade.invalid_die_step') if !Swade.is_valid_die_step?(self.die_step)
        return nil
      end
      
      def check_valid_attribute
        return t('Swade.invalid_attribute_name') if !Swade.is_valid_attribute_name?(self.attribute_name)
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.target_name
        return nil if Swade.can_manage_attributes?(enactor)
        return t('dispatcher.not_allowed')
      end     
      
      def check_chargen_locked
        return nil if Swade.can_manage_attributes?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def check_rating
        return nil if Swade.can_manage_attributes?(enactor)
        Swadecheck_max_starting_rating(self.die_step, 'max_attribute_step')
      end
      
      def handle
	  
		
        ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
		  #enactor.update(acltest: self.acltest)
          attr = Swade.find_attribute(model, self.attribute_name)
			newacltest = " #{self.acltest}%r%r#{attr}%r%r#{model}%r%RDie Step: #{self.die_step}%r%RAttribute Name: #{self.attribute_name}%r%R"
			template = BorderedDisplayTemplate.new newacltest, "Before testing"
			client.emit template.render		  
          if (attr && self.die_step == '0')
            attr.delete
            client.emit_success t('Swade.attribute_removed')
            return
          end
          
          if (attr)
            attr.update(die_step: self.die_step)
			newacltest = " #{self.acltest}%r%r#{attr}%r%r#{model}%r%RDie Step: #{self.die_step}%r%RAttribute Name: #{self.attribute_name}%r%R"
			template = BorderedDisplayTemplate.new newacltest, "Attr set?"
			client.emit template.render
          else
            SwadeAttribute.create(name: self.attribute_name, die_step: self.die_step, character: model)
			newacltest = " #{self.acltest}%r%r#{attr}%r%r#{model}%r%RDie Step: #{self.die_step}%r%RAttribute Name: #{self.attribute_name}%r%R"
			template = BorderedDisplayTemplate.new newacltest, "Attr Not Set?"
			client.emit template.render
          end

          client.emit_success t('Swade.attribute_set')
        end
      end
    end
  end
end