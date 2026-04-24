module AresMUSH
  module Website
    class PageListExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :pages
                     
      def initialize(pages)
        @pages = pages
        super File.dirname(__FILE__) + "/page_list.erb"        
      end      
    end
    
    class PageListMarkdownExtension
      def self.regex
        /\[\[pagelist ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        helper = TagMatchHelper.new(input)

        matches = WikiPage.all.select { |p| match_tag(p, helper) }
        pages = matches.sort_by { |m| m.title }.map { |m| {heading: m.heading, name: m.name} }
        
        template = PageListExtensionTemplate.new(pages)
        template.render

      end
      
      def self.match_tag(page, helper)
        tags = page.content_tags
        ((tags & helper.or_tags).any? && 
        (tags & helper.exclude_tags).empty?) &&
        (helper.required_tags & tags == helper.required_tags) 
      end
    end
  end
end
