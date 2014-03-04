module AresMUSH
  class Line
    def self.show(id = "1")
      "#{Global.config['skin']["line" + id]}"      
    end
  end
end
