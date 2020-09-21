module AresMUSH
  module ACL_CharModel
    class ACL_CharModelTemplate < ErbTemplateRenderer
             
      attr_accessor :pair
                     
      def initialize(pair)
        @pair = pair
	  end
	  
	  def quickview(model)
        model.inspect
      end
      
    end
  end
end

