module AresMUSH
  module BorderedDisplay
    def self.text(text, title = nil, leading_newline = true)
      output = "%l1"
      if (!title.nil?)
        output << "%r%xh#{title}%xn%r"
      end
      output << "%r" if leading_newline
      output << text
      output << "%r%l1"
      return output
    end
  
    def self.list(items, title = nil)
      output = ""
      if (!items.nil?)
        items.each do |i|
          output << "%r" << i
        end
      end
      return BorderedDisplay.text(output, title, false)
    end
  
    def self.table(items, column_width = 20, title = nil)
      output = ""
      if (!items.nil?)
        count = 0
        items_per_line = 78 / column_width
        items.each do |i|
          if (count % items_per_line == 0)
            output << "%r"
          end
          output << i.truncate(column_width - 1).ljust(column_width)
          count = count + 1
        end
      end
      return BorderedDisplay.text(output, title, false)
    end
  end
end