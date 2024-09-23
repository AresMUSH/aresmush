module AresMUSH
  module Website
    
    class CreateWikiExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :button_text, :query_str, :css
                     
      def initialize(button_text, query_str, css)
        @button_text = button_text
        @query_str = query_str
        @css = css
        
        super File.dirname(__FILE__) + "/create_wiki.erb"        
      end      
    end
    
    class CreateWikiPageButton
      def self.regex
        /\[\[createwiki ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input
        
        category = nil
        template = nil
        css = nil
        button = "Create Page"
        query = []
        
        options = input.split('|')
        options.each do |opt|
          option_name = opt.before('=') || ""
          option_value = opt.after('=') || ""
          
          case option_name.downcase.strip
          when 'category'
            query << "category=#{option_value}"
          when 'template'
            query << "template=#{option_value}"
          when 'class'
            css = option_value
          when 'tags'
            query << "tags=#{option_value}"
          when 'button'
            button = option_value
          end
        end

        query_str = nil
        if (query.any?)
          query_str = "?#{query.join('&')}"
        end
        
        template = CreateWikiExtensionTemplate.new(button, query_str, css)
        template.render
        
      end
    end
  end
end


