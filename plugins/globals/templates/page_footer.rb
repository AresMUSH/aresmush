module AresMUSH
  class PageFooterTemplate < ErbTemplateRenderer
          
    attr_accessor :page
    
    def initialize(page)
      @page = page
      super File.dirname(__FILE__) + "/page_footer.erb"
    end
    
    def page_text
      center(page, 15)
    end
    
  end
end
