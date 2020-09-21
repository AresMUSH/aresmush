module AresMUSH
  module ACL_CharModel
    class ACL_CharModelTemplate < ErbTemplateRenderer
             
      attr_accessor :list, :char, :viewer 
                     
      def initialize(model)
        @model = model
        super File.dirname(__FILE__) + "/acl_charmodel_template.erb"        
      end
	  
	  def quickview(model)
        model.inspect
      end
      
    end
  end
end

