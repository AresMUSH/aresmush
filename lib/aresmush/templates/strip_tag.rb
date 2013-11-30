module AresMUSH
  class StripTag < Liquid::Block
    def render(context)
      super.gsub /\n\s*\n/, "\n"
    end
  end
end