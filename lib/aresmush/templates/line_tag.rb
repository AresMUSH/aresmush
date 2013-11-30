module AresMUSH
  class LineTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      @id = params.strip
      @id = @id.empty? ? 1 : @id
      super
    end
  
    def render(context)
      "%l#{@id}"
    end
  end
end