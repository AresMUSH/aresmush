module AresMUSH
  module Who
    class WhoTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # some are defined in a common file.
      include CommonWhoFields
    
      attr_accessor :online_chars
      
      def initialize(online_chars)
        self.online_chars = online_chars
        super File.dirname(__FILE__) + "/who.erb"
      end
      
      def fields
        Global.read_config("who", "who_fields")
      end
      
      def who_header
        Global.read_config("who", "who_header")
      end
      
      def show_field(char, field_config)
        field = field_config["field"]
        value = field_config["value"]
        width = field_config["width"]
        
        # Check custom fields first
        field_eval = Who.custom_who_field(char, field, value, width)
        if (!field_eval)
          field_eval = Profile.general_field(char, field, value)
          return left(field_eval, width)
        end
        field_eval
      end
      
      def show_title(field_config)
        title = field_config["title"]
        width = field_config["width"]
        
        left(title, width)
      end
    end 
  end
end