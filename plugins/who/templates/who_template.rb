module AresMUSH
  module Who
    class WhoTemplate < ErbTemplateRenderer
      
      # NOTE!  Because so many fields are shared between the who and where templates,
      # they are defined in these two modules, found in other files in this directory.
      include WhoCharacterFields
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
        
        if (value)
          field_eval = send(field.to_sym, char, value)
        else
          field_eval = send(field.to_sym, char)
        end
        left(field_eval, width)
      end
      
      def show_title(field_config)
        title = field_config["title"]
        width = field_config["width"]
        
        left(title, width)
      end
    end 
  end
end