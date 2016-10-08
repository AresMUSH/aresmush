module AresMUSH
  module Bbs
    # Template for a particular bulletin board.
    class BoardTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      # List of all posts on the board, in order by date.
      attr_accessor :posts, :board
      
      def initialize(board, enactor)
        @board = board
        @posts = board.bbs_posts
        @enactor = enactor
        
        super File.dirname(__FILE__) + "/board.erb"
      end
      
      # Roles that can read this bbs.
      def can_read
        if (@board.read_roles.empty?)
          read_roles = t('bbs.everyone')
        else 
          read_roles = @board.read_roles.map { |r| r.name.titlecase }.join(", ")
        end
        "%xh#{t('bbs.can_read')}%xn #{read_roles}"
      end
      
      # Roles that can post to this bbs.
      def can_post
        if (@board.write_roles.empty?)
          write_roles = t('bbs.everyone') 
        else
          write_roles =@board.write_roles.map { |r| r.name.titlecase }.join(", ")
        end
        "%xh#{t('bbs.can_post')}%xn #{write_roles}"
      end
      
      def num(i)
        "#{i+1}"
      end
      
      def unread(post)
        post.is_unread?(@enactor) ? t('bbs.unread_marker') : " "
      end

      def author(post)
        !post.author ? t('bbs.deleted_author') : post.author.name
      end
      
      def date(post)
        OOCTime::Api.local_short_timestr(@enactor, post.created_at)
      end
    end
    
  end
end