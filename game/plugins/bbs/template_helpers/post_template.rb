module AresMUSH
  module Bbs
    # Template code for showing a specific bbs post.
    class PostTemplate
      include TemplateFormatters
            
      # List of all replies to this post, in order by date.
      # You would typically use this in a loop, such as in the example below.
      # Inside the loop, each reply would be referenced as 'r' and its 
      # counter index (0,1,2) as 'i'.
      #    <% replies.each_with_index do |r, i| %>
      #    <%= reply_title(r) %>
      #    <% end %>
      attr_accessor :replies
      
      def initialize(board, post, client)
        @board = board
        @post = post
        @replies = post.bbs_replies
        @client = client
      end
      
      # Board name.
      def name
        left(@board.name, 30)
      end
      
      # Post subject.
      def subject
        left(@post.subject, 30)
      end
      
      # Post author.
      def author
        name = @post.author.nil? ? t('bbs.deleted_author') : @post.author.name
        right(name, 46)
      end
      
      # Post created date.
      def date
        localdate = OOCTime.local_long_timestr(@client, @post.created_at)
        right(localdate, 46)
      end
      
      # Main body of the post.
      def message
        @post.message
      end
      
      # Reply title.
      # Requires a reply reference.  See 'replies' for more info.
      def reply_title(reply)
        name = reply.author.nil? ? t('bbs.deleted_author') : reply.author.name
        date = OOCTime.local_long_timestr(@client, reply.created_at)
        t('bbs.reply_title', :name => name, :date => date)
      end

      # Main body of the reply.
      # Requires a reply reference.  See 'replies' for more info.
      def reply_message(reply)
        reply.message
      end
    end
  end
end
