module AresMUSH
  module Website
    class WikiPreviewRequestHandler
      def handle(request)
        text = request.args[:text]
        
        {
          text: WebHelpers.format_markdown_for_html(text)
        }
      end
    end
  end
end