module AresMUSH
  module Bbs
    class PostTemplate
      include TemplateFormatters
            
      def initialize(board, post, client)
        @board = board
        @post = post
        @client = client
      end
      
      def name
        left(@board.name, 30)
      end
      
      def subject
        left(@post.subject, 30)
      end
      
      def author
        right(@post.author.name, 46)
      end
      
      def date
        right(@post.created_at.strftime("%Y-%m-%d"), 46)
      end
      
      def message
        @post.message
      end
    end
  end
end
