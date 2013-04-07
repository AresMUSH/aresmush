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
        if (self.respond_to?(field.first(".")))
          field = format_field(self.recursive_send(field), f)
        else
          field = format_field(field, f)
        end
        txt << field.to_s
      end      
      txt
    end

    def recursive_send(method)
      call_chain = method.split(".")
      obj = self
      call_chain.each do |m|
        if (obj.respond_to?(m))
          obj = obj.send(m)
        else
          obj = m
        end
      end
      obj
    end

    def format_field(field, options)
      justify = options["justify"] || "none"
      pad = options["padding"] || " "
      width = options["width"] || 0
      width = width.to_i
      color = options["color"] || nil

      field = trim_field(field, width)
      field = justify_field(field, justify, width, pad)
      field = color_field(field, color)
      field
    end

    def trim_field(field, width)
      if (width > 0)
        # Trim to 1 less than the justify to allow a space between fields.
        return field[0, width - 1]
      end
      field
    end

    def justify_field(field, justify, width, pad)
      if (justify.downcase == "left")
        return field.ljust(width, pad)
      elsif (justify.downcase == "right")
        return field.rjust(width, pad)
      elsif (justify.downcase == "center")
        return field.center(width, pad)  
      end
      field
    end

    def color_field(field, color)
      if (!color.nil?)
        ansi = ""
        color.each_char { |c| ansi << "%x#{c}"}
        return "#{ansi}#{field}%xn"
      end
      field
    end
  end
end