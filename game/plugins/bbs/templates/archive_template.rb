module AresMUSH
  module Bbs
    # Template for a specific bulletin board post.
    class ArchiveTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      # List of all replies to this post, in order by date.
      attr_accessor :post
      
      def initialize(post, client)
        @post = post
        @client = client
        super File.dirname(__FILE__) + "/archive.erb"
      end

      def date
        OOCTime::Api.local_long_timestr(@client, @post.created_at)
      end
      
      def author
        @post.author.nil? ? t('bbs.deleted_author') : @post.author.name
      end
      
      def reply_title(reply)
        rauthor = reply.author.nil? ? t('bbs.deleted_author') : reply.author.name
        rdate = OOCTime::Api.local_long_timestr(@client, reply.created_at)
        t('bbs.reply_title', :name => rauthor, :date => rdate)
      end
    end
  end
end
