module AresMUSH
  module ACL_CharModel
    class ACL_CharModelTemplate < ErbTemplateRenderer
             
      attr_accessor :char
                     
      def initialize(char)
        @char = name
        super File.dirname(__FILE__) + "/acl_charmodel_template.erb"		
	  end
	  
	  def quickview(model)
        model.inspect
      end
      
    end
  end
end

