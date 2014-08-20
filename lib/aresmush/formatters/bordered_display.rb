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
  
    def self.list(items, title = nil, footer = nil)
      output = ""
      if (!items.nil?)
        items.each do |i|
          output << "%r" << i
        end
      end
      if (!footer.nil?)
        output << "%r#{footer}"
      end
      return BorderedDisplay.text(output, title, false)
    end
    
    def self.paged_list(items, page, items_per_page = 20, title = nil, footer = nil)
      pagination = Paginator.paginate(items, page, items_per_page)
      if (pagination.out_of_bounds?)
        return BorderedDisplay.text(t('pages.not_that_many_pages'))
      else
        page_marker = t('pages.page_x_of_y', :x => page, :y => pagination.total_pages)
        page_marker = "%x!#{page_marker.center(78, '-')}%xn"
        footer = footer.nil? ? page_marker : "#{page_marker}%r#{footer}"
        return BorderedDisplay.list(pagination.page_items, title, footer)
      end
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