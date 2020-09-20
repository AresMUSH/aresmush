module AresMUSH    
  module Swade
    class StatNewSetCmd
      include CommandHandler
      
      attr_accessor :strength
 


      def parse_args
		self.strength = trim_arg(cmd.args)
	  end
	  
      def handle
        enactor.update(strength: self.strength)
        client.emit_success "Attribute set!"
      end
    end
  end
end