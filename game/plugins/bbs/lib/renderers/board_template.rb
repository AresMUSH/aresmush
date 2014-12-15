module AresMUSH
  module Bbs
    # The template code for showing a particular bulletin board.
    class BoardTemplate
      include TemplateFormatters
      
      # List of all posts on the board, in order by date.
      # You would typically use this in a loop, such as in the example below.
      # Inside the loop, each post would be referenced as 'p' and its 
      # counter index (0,1,2) as 'i'.
      #    <% posts.each_with_index do |p, i| -%> 
      #    <%= post_num(i) %> <%= post_subject(p) %>
      #    <% end %>
      attr_accessor :posts
      
      def initialize(board, client)
        @board = board
        @posts = board.bbs_posts
        @client = client
        @char = client.char
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
      
      # Player-friendly post number.
      # Requires a post index counter.  See 'posts' for more info.
      def post_num(i)
        "#{i+1}".rjust(3)
      end
      
      # Shows whether this post is read or not.
      # Requires a post reference.  See 'posts' for more info.
      def post_unread_status(post)
        unread = post.is_unread?(@char) ? t('bbs.unread_marker') : " "
        center(unread, 5)
      end

      # Post subject.
      # Requires a post reference.  See 'posts' for more info.
      def post_subject(post)
        left(post.subject,30)
      end

      # Post author.
      # Requires a post reference.  See 'posts' for more info.
      def post_author(post)
        name = post.author.nil? ? t('bbs.deleted_author') : post.author.name
        left(name,25)
      end
      
      # Post creation date.
      # Requires a post reference.  See 'posts' for more info.
      def post_date(post)
        OOCTime.local_short_timestr(@client, post.created_at)
      end
    end
    
  end
end