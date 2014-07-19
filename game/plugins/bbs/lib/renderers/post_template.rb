module AresMUSH
  module Bbs
    class PostTemplate
      include TemplateFormatters
            
      attr_accessor :replies
      
      def initialize(board, post)
        @board = board
        @post = post
        @replies = post.bbs_replies
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
      
      def reply_author(reply)
        name = reply.author.nil? ? t('bbs.deleted_author') : reply.author.name
      end
      
      def reply_date(reply)
        reply.created_at.strftime("%Y-%m-%d")
      end
      
      def reply_message(reply)
        reply.message
      end
    end
  end
end
