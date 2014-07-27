module AresMUSH
  module Bbs
    class PostTemplate
      include TemplateFormatters
            
      attr_accessor :replies
      
      def initialize(board, post, client)
        @board = board
        @post = post
        @replies = post.bbs_replies
        @client = client
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
        localdate = OOCTime.local_time_str(@client, @post.created_at)
        right(localdate, 46)
      end
      
      def message
        @post.message
      end
      
      def reply_author(reply)
        name = reply.author.nil? ? t('bbs.deleted_author') : reply.author.name
      end
      
      def reply_date(reply)
        OOCTime.local_time_str(@client, reply.created_at)
      end
      
      def reply_message(reply)
        reply.message
      end
    end
  end
end
