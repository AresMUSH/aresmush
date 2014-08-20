module AresMUSH
  class PaginateResults
    attr_accessor :current_page, :total_pages, :page_items
    
    def initialize(current_page, total_pages, page_items)
      @current_page = current_page
      @total_pages = total_pages
      @page_items = page_items
    end
    
    def out_of_bounds?
      self.current_page > self.total_pages
    end
  end
  
  module Paginator
    def self.paginate(items, page, items_per_page)
      page_index = page - 1
      if (page_index < 0)
        page_index = 0
      end
      
      offset = page_index * items_per_page
      page_batch = items[offset, items_per_page]
      total_pages = (items.count / items_per_page)
      if (items.count % items_per_page != 0)
        total_pages = total_pages + 1
      end
      
      return PaginateResults.new(page, total_pages, page_batch)
    end
  end
end