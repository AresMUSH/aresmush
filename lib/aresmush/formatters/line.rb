module AresMUSH
  class Line
    def self.show(id = "1")
      "#{Global.read_config("skin", "line" + id)}"
    end
  end
end
