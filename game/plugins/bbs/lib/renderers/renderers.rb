module AresMUSH
  module Bbs
    class BoardListRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/boards.erb")
      end
      
      def render(client)
        data = BoardListTemplate.new(client)
        @renderer.render(data)
      end
    end
    
    class BoardRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/board.erb")
      end
      
      def render(board, client)
        data = BoardTemplate.new(board, client)
        @renderer.render(data)
      end
    end
    
    class PostRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/post.erb")
      end
      
      def render(board, post, client)
        data = PostTemplate.new(board, post, client)
        @renderer.render(data)
      end
    end
  end
end