module AresMUSH
  class PaginateResults
    attr_accessor :current_page, :total_pages, :items, :starting_index
    
    def initialize(current_page, total_pages, items, starting_index)
      @current_page = current_page
      @total_pages = total_pages
      @items = items
      @starting_index = starting_index
    end
    
    def page_items
      return [ out_of_bounds_msg ] if (out_of_bounds?)
      return @items
    end
        
    def out_of_bounds?
      self.current_page > self.total_pages
    end
    
    def out_of_bounds_msg
      self.current_page == 1 ? t('pages.no_items') : t('pages.not_that_many_pages')
    end
    
    def page_marker
      t('pages.page_x_of_y', :x => self.current_page, :y => self.total_pages)
    end
    
    def page_footer
      # This template is defined in the utils plugin so it can be easily customized
      template = PageFooterTemplate.new(page_marker)
      template.render
    end
  end
  
  module Paginator
    # @return [PaginateResults]
    def self.paginate(items, page, items_per_page)
      items = items.to_a
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
      
      return PaginateResults.new(page, total_pages, page_batch, offset)
    end
  end
end