module AresMUSH
  module Bbs
    mattr_accessor :board_list_renderer, :board_renderer, :post_renderer
        
    def self.build_renderers
        self.board_list_renderer = BoardListRenderer.new
        self.board_renderer = BoardRenderer.new
        self.post_renderer = PostRenderer.new
    end
    
    class BoardListRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/boards.erb")
      end

      def render(client)
        data = BoardListTemplate.new(client.char)
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