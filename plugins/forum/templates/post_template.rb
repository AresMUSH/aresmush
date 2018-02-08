module AresMUSH
  module Forum
    class PostTemplate < ErbTemplateRenderer
            
      # List of all replies to this post, in order by date.
      attr_accessor :replies, :category, :post
      
      def initialize(category, post, enactor)
        @category = category
        @post = post
        @replies = post.bbs_replies
        @enactor = enactor
        super File.dirname(__FILE__) + "/post.erb"
      end
      
      def category_and_post
        "#{@category.name} #{@post.reference_str}"
      end
      
      def author
        @post.author_name
      end
      
      def date
        @post.created_date_str(@enactor)
      end
      
      def reply_title(reply)
        name = reply.author_name
        date = OOCTime.local_long_timestr(@enactor, reply.created_at)
        t('forum.reply_title', :name => name, :date => date)
      end
    end
  end
end
