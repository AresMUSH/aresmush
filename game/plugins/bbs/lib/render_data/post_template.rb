module AresMUSH
  module Bbs
    class PostTemplate
      include TemplateFormatters
            
      attr_accessor :replies
      
      def initialize(board, post, replies)
        @board = board
        @post = post
        @replies = replies
      end
      
      def name
        left(@board.name, 30)
      end
      
      def subject
        left(@post.subject, 30)
      end
      
      def author
        name = @post.author.nil? ? t('bbs.deleted_author') : @post.author.name
        right(name, 46)
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
