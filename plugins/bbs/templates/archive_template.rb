module AresMUSH
  module Bbs
    # Template for a specific bulletin board post.
    class ArchiveTemplate < ErbTemplateRenderer
            
      # List of all replies to this post, in order by date.
      attr_accessor :posts
      
      def initialize(posts, enactor)
        @posts = posts
        @enactor = enactor
        super File.dirname(__FILE__) + "/archive.erb"
      end

      def date(post)
        OOCTime.local_long_timestr(@enactor, post.created_at)
      end
      
      def author(post)
        !post.author ? t('bbs.deleted_author') : post.author.name
      end
      
      def reply_title(reply)
        rauthor = !reply.author ? t('bbs.deleted_author') : reply.author.name
        rdate = OOCTime.local_long_timestr(@enactor, reply.created_at)
        t('bbs.reply_title', :name => rauthor, :date => rdate)
      end
    end
  end
end
