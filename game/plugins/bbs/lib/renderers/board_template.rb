module AresMUSH
  module Bbs
    class BoardTemplate
      include TemplateFormatters
      
      attr_accessor :posts
      
      def initialize(board, client)
        @board = board
        @posts = board.bbs_posts
        @client = client
        @char = client.char
      end
      
      def can_read
        read_roles = @board.read_roles.empty? ? t('bbs.everyone') : @board.read_roles.join(", ")
        "%xh#{t('bbs.can_read')}%xn #{read_roles}"
      end
      
      def can_post
        write_roles = @board.write_roles.empty? ? t('bbs.everyone') : @board.write_roles.join(", ")
        "%xh#{t('bbs.can_post')}%xn #{write_roles}"
      end

      def name
        left(@board.name, 30)        
      end
      
      def desc
        @board.description
      end
      
      def post_num(i)
        "#{i+1}".rjust(3)
      end
      
      def post_unread_status(post)
        unread = post.is_unread?(@char) ? t('bbs.unread_marker') : " "
        center(unread, 5)
      end
      
      def post_subject(post)
        left(post.subject,30)
      end
      
      def post_author(post)
        name = post.author.nil? ? t('bbs.deleted_author') : post.author.name
        left(name,25)
      end
      
      def post_date(post)
        OOCTime.local_short_timestr(@client, post.created_at)
      end
    end
    
  end
end