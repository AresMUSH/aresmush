module AresMUSH
  module Bbs
    class BoardListRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/boards.erb")
      end
      
      def render(client)
        boards = BbsBoard.all_sorted.map { |b| BoardListBoardTemplate.new(b, client.char) }
        data = BoardListTemplate.new(client.char, boards)
        @renderer.render(data)
      end
    end
    
    class BoardRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/board.erb")
      end
      
      def render(board, client)
        posts = board.bbs_posts.map { |p| BoardPostTemplate.new(p, client.char) }        
        data = BoardTemplate.new(board, client.char, posts)
        @renderer.render(data)
      end
    end
    
    class PostRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/post.erb")
      end
      
      def render(board, post, client)
        replies = post.bbs_replies.map { |r| ReplyTemplate.new(r) }
        data = PostTemplate.new(board, post, replies)
        @renderer.render(data)
      end
    end
  end
end