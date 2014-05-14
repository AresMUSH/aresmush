module AresMUSH
  module Bbs
    class BoardTemplate
      include TemplateFormatters
      
      attr_accessor :posts
      
      def initialize(board, char, posts)
        @board = board
        @posts = posts
        @char = char
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
    end
    
    class BoardPostTemplate
      include TemplateFormatters
      
      def initialize(post, char)
        @post = post
        @char = char
      end
      
      def num(i)
        "#{i+1}".rjust(2)
      end
      
      def unread_status
        unread = @post.is_unread?(@char) ? t('bbs.unread_marker') : " "
        center(unread, 5)
      end
      
      def subject
        left(@post.subject,30)
      end
      
      def author
        name = @post.author.nil? ? t('bbs.deleted_author') : @post.author.name
        left(name,25)
      end
      
      def date
        @post.created_at.strftime("%Y-%m-%d")
      end
    end
  end
end