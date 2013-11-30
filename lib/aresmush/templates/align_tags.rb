module AresMUSH
  class LeftTag < Liquid::Block
    def initialize(tag_name, params, tokens)
      @width = params.strip.to_i
      @width = @width == 0 ? 78 : @width
      super
    end
      
    def render(context)
      super.truncate(@width).ljust(@width)
    end
  end
  
  class CenterTag < Liquid::Block
    def initialize(tag_name, params, tokens)
      @width = params.strip.to_i
      @width = @width == 0 ? 78 : @width
      super
    end
      
    def render(context)
      super.truncate(@width).center(@width)
    end
  end
  
  class RightTag < Liquid::Block
    def initialize(tag_name, params, tokens)
      @width = params.strip.to_i
      @width = @width == 0 ? 78 : @width
      super
    end
      
    def render(context)
      super.truncate(@width).rjust(@width)
    end
  end
end