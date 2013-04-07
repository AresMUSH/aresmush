module AresMUSH  
  
  class TemplateRenderer  
    
    def initialize
      # Override with an alternative data source.  The template will check the object itself, then
      # the data source, for methods that correspond to the field names.
      @data = nil
    end
    
    def template
      # Override with field config.  This should be an array of field hashes.  Each field may have
      # the following params:
      #    {
      #       "field"   => method name or raw text       # Required
      #       "justify" =>  left, right, center or none  # Optional - defaults to none
      #       "width"   =>  justify width                # Optional - defaults to 10
      #       "padding" =>  padding char for justifying  # Optional - defaults to space
      #    }
      #
      []
    end
    
    def method_missing(method, *args, &block)
      if (!@data.nil? && @data.respond_to?(method))
        return @data.send(method)
      end
      super
    end   
    
    def respond_to?(method)
      if (!@data.nil? && @data.respond_to?(method))
        return true
      end
      super
    end
    
    def render
      txt = ""
      template.each do |f|
        type = f["type"]
        field = f["field"]
        if (self.respond_to?(field))
          field = format_field(self.send(field), f)
        else
          field = format_field(field, f)
        end
        txt << field.to_s
      end      
      txt
    end
    
    def format_field(field, options)
      justify = options["justify"] || "none"
      pad = options["padding"] || " "
      width = options["width"] || 10
      if (justify.downcase == "left")
        return field.ljust(width.to_i, pad)
      elsif (justify.downcase == "right")
        return field.rjust(width.to_i, pad)
      elsif (justify.downcase == "center")
        return field.center(width.to_i, pad)
      else
        return field
      end
    end
  end
end