module AresMUSH
  module Website
    class StartCollapsibleMarkdownExtension
      def self.regex
        /\[\[collapsible ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        button_text = matches[1]
        
        return "" if !button_text 

        
        sinatra.erb :"collapsible", :locals => {
          button_text: button_text, 
          id: SecureRandom.uuid.gsub('-','')  
        }, :layout => false
      end
    end

    class EndCollapsibleMarkdownExtension
      def self.regex
        /\[\[\/collapsible\]\]/i
      end
      
      def self.parse(matches, sinatra)
        "</div>"
      end
    end
  end
end