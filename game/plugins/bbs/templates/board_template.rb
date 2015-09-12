module AresMUSH
  module Bbs
    # Template for a particular bulletin board.
    class BoardTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      # List of all posts on the board, in order by date.
      attr_accessor :posts
      
      def initialize(board, client)
        @board = board
        @posts = board.bbs_posts
        @char = client.char
        
        super client
      end
      
      def build_template
        text = "%l1%r"
        text << "%xh#{name}%xn%r"
        text << "#{desc}%r"
        text << "%l2"
         
        posts.each_with_index do |p, i|
          text << "%r"
          text << post_num(i)
          text << " "
          text << post_unread_status(p)
          text << " "
          text << post_subject(p)
          text << " "
          text << post_author(p)
          text << " "
          text << post_date(p)
        end

        text << "%r%l2%r"
        text << "#{can_read}    #{can_post}%r"
        text << "%l1"
        
        text
      end
      
      # Roles that can read this bbs.
      def can_read
        read_roles = @board.read_roles.empty? ? t('bbs.everyone') : @board.read_roles.join(", ")
        "%xh#{t('bbs.can_read')}%xn #{read_roles}"
      end
      
      # Roles that can post to this bbs.
      def can_post
        write_roles = @board.write_roles.empty? ? t('bbs.everyone') : @board.write_roles.join(", ")
        "%xh#{t('bbs.can_post')}%xn #{write_roles}"
      end

      # Board name.
      def name
        left(@board.name, 30)        
      end
      
      # Board description.
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
        OOCTime.local_short_timestr(self.client, post.created_at)
      end
    end
    
  end
end