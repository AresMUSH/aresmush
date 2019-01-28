module AresMUSH
  class Line
    def self.show(id = "h")
      case id.downcase
      when "h"
        id = "header"
      when "d", "2"
        id = "divider"
      when "f"
        id = "footer"
      when "p", "1"
        id = "plain"
      else
        id = id
      end
      
      # This template is defined in the utils plugin so it can be customized.
      template = LineTemplate.new(id)
      template.render
    end
  end
end
