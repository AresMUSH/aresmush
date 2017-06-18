module AresMUSH
  class BorderedListTemplate < ErbTemplateRenderer
          
    attr_accessor :list, :title, :subfooter, :subtitle, :leading_newline
    
    def initialize(list, title = nil, subfooter = nil, subtitle = nil, leading_newline = true)

      @list = list
      @title = title
      @subtitle = subtitle
      @subfooter = subfooter
      @leading_newline = leading_newline
      
      super File.dirname(__FILE__) + "/bordered_list.erb"
    end
  end
end
