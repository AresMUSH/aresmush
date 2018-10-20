module AresMUSH
  module Demographics
    class CompleteCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/complete_census.erb"
      end
      
      def fields
        Global.read_config("demographics", "census_fields")
      end      
      
      def show_field(char, field_config)
        field = field_config["field"]
        value = field_config["value"]
        width = field_config["width"]
        
        field_eval = Profile.general_field(char, field, value)
        left(field_eval, width)
      end
      
      def show_title(field_config)
        title = field_config["title"]
        width = field_config["width"]
        
        left(title, width)
      end
      
      def demographic(char, value)
        char.demographic(value)
      end
      
      def name(char)
        Demographics.name_and_nickname(char)
      end
      
      def group(char, value)
        char.group(value)
      end
    end
  end
end
