module AresMUSH
  module Website
    class WikiExportWikiPageTemplate < ErbTemplateRenderer
            
      attr_accessor :page
      def initialize(page)
        @page = page
        
        super File.dirname(__FILE__) + "/wiki_page.erb"
      end
      
      def text
        Website.format_markdown_for_html @page.text
      end
     
    end
  end
end