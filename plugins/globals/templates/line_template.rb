module AresMUSH
  class LineTemplate < ErbTemplateRenderer
          
    attr_accessor :id
    
    def initialize(id)
      @id = id
      super File.dirname(__FILE__) + "/line.erb"
    end
    
    def line
      "#{Global.read_config("skin", id)}"
    end
  end
end
