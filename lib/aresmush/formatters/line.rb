module AresMUSH
  class Line
    def self.show(id = "1")
      "#{Global.config['theme']["line" + id]}"      
    end
  end
end
