module AresMUSH
  class BorderedPagedListTemplate < ErbTemplateRenderer
          
    attr_accessor :title, :subfooter, :subtitle, :page, :items_per_page, :page_marker
    
    def initialize(list, page, items_per_page = 25, title = nil, subfooter = nil, subtitle = nil)

      @title = title
      @subtitle = subtitle
      @subfooter = subfooter

      @paginator =  Paginator.paginate(list, page, items_per_page)
      
      @page_marker = t('pages.page_x_of_y', :x => page, :y => @paginator.total_pages)
      super File.dirname(__FILE__) + "/bordered_paged_list.erb"
    end
  end
end
