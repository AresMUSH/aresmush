module AresMUSH
  module ACL_CharModel
    class ACL_CharModelTemplate < ErbTemplateRenderer
             
      attr_accessor :char
                     
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/acl_charmodel_template.erb"		
	  end
	  
	  def niceview(model)
		model.to_yaml
      end

	  def swadestats(model)
        model.swade_stats.to_a.sort_by { |a| a.name }
          .each_with_index
            .map do |a, i| 
              linebreak = i % 2 == 0 ? "\n" : ""
              title = left("#{ a.name }:", 15)
              step = left(a.rating, 20)
              "#{linebreak}%xh#{title}%xn #{step}"
      end
	end
  end
end

