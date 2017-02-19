module AresMUSH
  module Bbs
    # Template for a specific bulletin board post.
    class PostTemplate < ErbTemplateRenderer
            
      # List of all replies to this post, in order by date.
      attr_accessor :replies, :board, :post
      
      def initialize(board, post, enactor)
        @board = board
        @post = post
        @replies = post.bbs_replies
        @enactor = enactor
        super File.dirname(__FILE__) + "/post.erb"
      end
      
      def board_and_post
        "#{@board.name} #{@post.reference_str}"
      end
      
      def author
        @post.author_name
      end
      
      def date
        OOCTime::Api.local_long_timestr(@enactor, @post.created_at)
      end
      
      def reply_title(reply)
        name = reply.author_name
        date = OOCTime::Api.local_long_timestr(@enactor, reply.created_at)
        t('bbs.reply_title', :name => name, :date => date)
      end
    end
  end
end
