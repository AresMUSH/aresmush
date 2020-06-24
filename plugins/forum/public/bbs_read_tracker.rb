module AresMUSH
  class ReadTracker

    attribute :forum_read_posts, :type => DataType::Array, :default => []

    def is_forum_post_unread?(post)
      posts = self.forum_read_posts || []
      !posts.include?("#{post.id}")
    end
    
    def mark_forum_post_read(post)
      posts = self.forum_read_posts || []
      posts << post.id.to_s
      self.update(forum_read_posts: posts.uniq)
    end

    def mark_forum_post_unread(post)
      posts = self.forum_read_posts || []
      posts.delete post.id.to_s
      self.update(forum_read_posts: posts.uniq)
    end
  end
end