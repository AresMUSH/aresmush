module AresMUSH
  module Help
    class HelpFileTemplate
      include TemplateFormatters

      attr_accessor :topic
      
      def initialize(topic)
        @topic = topic
        metadata = Help.topic_metadata(topic)
        contents = Help.topic_contents(topic)
        
        markdown = MarkdownFormatter.new
        display = markdown.to_mush(contents).chomp
        
        
        @template = Erubis::Eruby.new(display, :bufvar=>'@output')
      end
      
      def render
        @template.evaluate(self)
      end		   
      
      

    end
  end
end
