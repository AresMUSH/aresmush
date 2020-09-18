module AresMUSH    
  module Swade
    class AttributeNewSetCmd
      include CommandHandler
      
      attr_accessor :aaaaa
 


      def parse_args
		self.aaaaa = trim_arg(cmd.args)
	  end
	  
      def handle
        enactor.update(aaaaa: self.aaaaa)
        client.emit_success "Attribute set!"
      end
    end
  end
end