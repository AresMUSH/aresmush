module AresMUSH
  class LineWithTextTemplate < ErbTemplateRenderer
          
    attr_accessor :text, :style
    
    def initialize(text, style_name)
      @text = text || ""
      config = Global.read_config("skin", "line_with_text") || {}
      @style = config[style_name || 'default'] || {}
      super File.dirname(__FILE__) + "/line_with_text.erb"
    end
    
    def formatted_text
      max_length = 78 - self.text_position - self.bracket_length
      self.text.truncate(max_length)
    end
        
    def text_position
      if (self.align_center?)
        (78 - self.text.length - self.bracket_length) / 2
      else
        self.style['text_position'] || 5
      end
    end
    
    def pad_char
      self.style['pattern'] || "-"
    end
    
    def pad_length
      self.pad_char.length
    end
        
    def align_center?
     ( @style['text_position'] || "").to_s.downcase == 'center'
    end
    
    def right_border
      repeat_length = 78 - self.text_position - text.length - self.bracket_length
      return "" if repeat_length <= 0

      repeat_times = repeat_length / self.pad_length
      repeat_remainder = repeat_length % self.pad_length
      if (repeat_remainder > 0)
        extra_pattern = self.pad_char[0..repeat_remainder-1]
      else
        extra_pattern = ""
      end
      line = right('', repeat_times, self.pad_char)
      "#{line}#{extra_pattern}"
    end
    
    def color
      self.style['color'] || "%x!"
    end

    def left_border
      repeat_length = self.text_position
      repeat_times = repeat_length / self.pad_length
      repeat_remainder = repeat_length % self.pad_length
      if (repeat_remainder > 0)
        extra_pattern = self.pad_char[0..repeat_remainder-1]
      else
        extra_pattern = ""
      end
      line = left('', repeat_times, self.pad_char)
      "#{line}#{extra_pattern}"
    end
    
    def bracket_length
      self.left_bracket.length + self.right_bracket.length
    end
    
    def left_bracket
      self.style['left_bracket'] || '[ '
    end
    
    def right_bracket
      self.style['right_bracket'] || ' ]'
    end
  end
end
