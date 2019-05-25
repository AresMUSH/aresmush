module AresMUSH
  class BorderedTableTemplate < ErbTemplateRenderer
          
    attr_accessor :list, :column_width, :title, :subfooter, :subtitle, :lines
    
    def initialize(list, column_width = 20, title = nil, subfooter = nil, subtitle = nil)

      @list = list
      @title = title
      @subtitle = subtitle
      @subfooter = subfooter
      @column_width = column_width
      @lines = []
      
      items_per_line = 78 / column_width
      count = 0
      current_line = ""
            
      list.each do |i|
        if (count % items_per_line == 0)
          @lines << current_line
          current_line = ""
        end
        current_line << i.truncate(column_width - 1).ljust(column_width)
        count = count + 1
      end
      
      if (list.count % items_per_line != 0)
        @lines << current_line
      end
      
      super File.dirname(__FILE__) + "/bordered_table.erb"
    end
  end
end
