module AresMUSH
  module Bbs
    # Template for a particular bulletin board.
    class BoardTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      # List of all posts on the board, in order by date.
      attr_accessor :posts, :board, :char
      
      def initialize(board, client)
        @board = board
        @posts = board.bbs_posts
        @char = client.char
        
        super File.dirname(__FILE__) + "/board.erb", client
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
      
      def num(i)
        "#{i+1}"
      end
      
      def unread(post)
        post.is_unread?(@char) ? t('bbs.unread_marker') : " "
      end

      def author(post)
        post.author.nil? ? t('bbs.deleted_author') : post.author.name
      end
      
      def date(post)
        OOCTime::Interface.local_short_timestr(self.client, post.created_at)
      end
    end
    
  end
end