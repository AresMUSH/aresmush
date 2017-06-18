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
      
      "#{Global.read_config("skin", id)}"
    end
  end
end
