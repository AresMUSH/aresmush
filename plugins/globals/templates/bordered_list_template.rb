module AresMUSH
  class BorderedListTemplate < ErbTemplateRenderer
          
    attr_accessor :list, :title, :subfooter, :subtitle
    
    def initialize(list, title = nil, subfooter = nil, subtitle = nil)

      @list = list
      @title = title
      @subtitle = subtitle
      @subfooter = subfooter
      
      super File.dirname(__FILE__) + "/bordered_list.erb"
    end
  end
end
