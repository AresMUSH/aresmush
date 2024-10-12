module AresMUSH
  module Website
    
    class CollapsibleExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :button_text, :id
                     
      def initialize(button_text)
        @button_text = button_text
        @id = "col#{SecureRandom.uuid.gsub('-','')}"
        super File.dirname(__FILE__) + "/collapsible.erb"        
      end      
    end
    
    class StartCollapsibleMarkdownExtension
      def self.regex
        /\[\[collapsible ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        button_text = matches[1]
        
        return "" if !button_text 
       
        template = CollapsibleExtensionTemplate.new(button_text)
        template.render
      end
    end

    class EndCollapsibleMarkdownExtension
      def self.regex
        /\[\[\/collapsible\]\]/i
      end
      
      def self.parse(matches)
        "</div>"
      end
    end
  end
end