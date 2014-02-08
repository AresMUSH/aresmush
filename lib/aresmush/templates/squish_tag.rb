module AresMUSH
  class SquishTag < Liquid::Block
    def render(context)
      super.gsub /\n/, ""
    end
  end
end