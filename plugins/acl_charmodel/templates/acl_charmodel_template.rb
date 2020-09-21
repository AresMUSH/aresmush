module AresMUSH
  module ACL_CharModel
    class ACL_CharModelTemplate < ErbTemplateRenderer
             
      attr_accessor :char
                     
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/acl_charmodel_template.erb"		
	  end
	  
	  def quickview(model)
        model.inspect
      end

	  def niceview(model)
		#model.attributes.each do |key, value|
		  #client.emit "#{key}: #{value}"
		#end
		
		model.map { |k,v| "%r%tKey: #{k} - Value: #{v}"}
		
		#model.id
      end
	end
  end
end

