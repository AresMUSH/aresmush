require 'mustache'

module AresMUSH
  class MustacheFormatter < Mustache
    
    def render_default
      render(template)
    end
    
    # Override wth your mustache template
    def template
      ""
    end
  end
end