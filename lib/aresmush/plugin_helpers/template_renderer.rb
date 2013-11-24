module AresMUSH  

  class TemplateRenderer  

    # The template should be an array of field hashes.  Each field may have
    # the following params:
    #    {
    #     ONE of the following is required:
    #       "variable"  => method name, on either the main object or data object 
    #       "text"      => raw text
    #       "line"      => line number
    #       "new_line"  => line break
    #
    #     Additional formatting params are optional:
    #       "align"  =>  left, right, center or none  # Optional - defaults to none
    #       "width"    =>  align width                # Optional - defaults to none
    #       "padding " =>  padding char for aligning  # Optional - defaults to space
    #       "color"    =>  ansi code or color name      # Optional - defaults to none
    #    }
    #

    def initialize(template, data = nil)
      @data = data
      @template = template
      Global.logger.debug("Initializing template renderer with temp: #{template}, data: #{data}")
    end

    attr_accessor :template, :data

    def method_missing(method, *args, &block)
      if (!@data.nil? && @data.respond_to?(method))
        Global.logger.debug("Reading data member #{method} for template.")
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
      render_str = ""
      
      Global.logger.warn("Template not specified for #{self}.") and return "" if template.nil?
      
      Global.logger.info("Rendering template #{self}.")
      
      template.each do |f|
        var = f["variable"]
        txt = f["text"]
        line = f["line"]
        new_line = f["new_line"]
        
        if (!var.nil?)
          if (self.respond_to?(var.first(".")))
            field = format_field(self.recursive_send(var), f)
          else
            field = format_field(var, f)
          end
        elsif (!line.nil?)
          field = "%l#{line}"
        elsif (!new_line.nil?)
          field = "%r"
        else
          field = format_field(txt, f)
        end
        render_str << field.to_s
      end      
      render_str
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
      align = options["align"] || "none"
      pad = options["padding"] || " "
      width = options["width"] || 0
      width = width.to_i
      color = options["color"] || nil

      field = trim_field(field, width)
      field = align_field(field, align, width, pad)
      field = color_field(field, color)
      field
    end

    def trim_field(field, width)
      if (width > 0)
        # Trim to 1 less than the align width to allow a space between fields.
        return field[0, width - 1]
      end
      field
    end

    def align_field(field, align, width, pad)
      if (align.downcase == "left")
        return field.ljust(width, pad)
      elsif (align.downcase == "right")
        return field.rjust(width, pad)
      elsif (align.downcase == "center")
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