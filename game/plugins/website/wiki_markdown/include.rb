module AresMUSH
  module Website
    class IncludeMarkdownExtension
      def self.regex
        /\[\[include ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        begin
          sinatra.erb "/wiki/#{input}".to_sym
        rescue
          "<div class=\"alert alert-danger\">Include not found: #{input}</div>"
        end
      end
    end
  end
end
