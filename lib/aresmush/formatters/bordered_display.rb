module AresMUSH
  module BorderedDisplay
    def self.text(text, title = nil, footer = nil)
      template = BorderedDisplayTemplate.new(text, title, footer, nil)
      return template.render
    end
  
    def self.list(items, title = nil, footer = nil)
      template = BorderedListTemplate.new(items, title, footer, nil)
      return template.render
    end
    
    def self.subtitled_list(items, title, subtitle, footer = nil)
      template = BorderedListTemplate.new(items, title, footer, subtitle)
      return template.render
    end
    
    def self.paged_list(items, page, items_per_page = 25, title = nil, footer = nil)
      template = BorderedPagedListTemplate.new(items, page, items_per_page, title, footer)
      return template.render
    end
  
    def self.table(items, column_width = 20, title = nil)
      template = BorderedTableTemplate.new(items, column_width, title, nil, nil)
      return template.render
    end
  end
end