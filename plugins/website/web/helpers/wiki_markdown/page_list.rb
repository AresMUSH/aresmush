module AresMUSH
  module Website
    class PageListMarkdownExtension
      def self.regex
        /\[\[pagelist ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input

        helper = TagMatchHelper.new(input)

        matches = WikiPage.all.select { |p| 
          ((p.tags & helper.or_tags).any? && 
          (p.tags & helper.exclude_tags).empty?) &&
          (helper.required_tags & p.tags == helper.required_tags) 
        }

        sinatra.erb :"wiki/page_list", :locals => {
          pages: matches
        }, :layout => false
      end
    end
  end
end
