module AresMUSH    
  module Swade
    class AttributeSetCmd
      include CommandHandler
      
      attr_accessor :target_name, :attribute_name, :die_step, :aaaaa
 


      def parse_args
		self.aaaaa = "Testing New CMD"
	  end
	  
      def handle
        enactor.update(aaaaa: self.aaaaa)
        client.emit_success "Attribute set!"
      end
    end
  end
end