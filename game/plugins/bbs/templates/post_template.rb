module AresMUSH
  module Bbs
    # Template for a specific bulletin board post.
    class PostTemplate < AsyncTemplateRenderer
      include TemplateFormatters
            
      # List of all replies to this post, in order by date.
      attr_accessor :replies
      
      def initialize(board, post, client)
        @board = board
        @post = post
        @replies = post.bbs_replies
        super client
      end
      
      def build_template
        text = "%l1%r"
        text << "%xh#{name}%xn #{author}%r"
        text << "#{subject} #{date}%r"
        text << "%l2%r"
        text << "#{message}"
        replies.each_with_index do |r, i|
          text << "%r%l2%r"
          text << "#{reply_title(r)}%r"
          text << reply_message(r) 
        end
        text << "%r%l1"

        text
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
        localdate = OOCTime.local_long_timestr(self.client, @post.created_at)
        right(localdate, 46)
      end
      
      def message
        @post.message
      end
      
      def reply_title(reply)
        name = reply.author.nil? ? t('bbs.deleted_author') : reply.author.name
        date = OOCTime.local_long_timestr(self.client, reply.created_at)
        t('bbs.reply_title', :name => name, :date => date)
      end

      def reply_message(reply)
        reply.message
      end
    end
  end
end
