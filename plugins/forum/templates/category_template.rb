module AresMUSH
  module Forum
    class ForumCategoryTemplate < ErbTemplateRenderer
      
      # List of all posts on the category, in order by date.
      attr_accessor :category
      
      def initialize(category, enactor)
        @category = category
        @enactor = enactor
        
        super File.dirname(__FILE__) + "/category.erb"
      end
      
      # Roles that can read this category.
      def can_read
        if (@category.read_roles.empty?)
          read_roles = t('forum.everyone')
        else 
          read_roles = @category.read_roles.map { |r| r.name.titlecase }.join(", ")
        end
        "%xh#{t('forum.can_read')}%xn #{read_roles}"
      end
      
      # Roles that can post to this category.
      def can_post
        if (@category.write_roles.empty?)
          write_roles = t('forum.everyone') 
        else
          write_roles =@category.write_roles.map { |r| r.name.titlecase }.join(", ")
        end
        "%xh#{t('forum.can_post')}%xn #{write_roles}"
      end
      
      def num(i)
        "#{i+1}"
      end

      def unread(post)
        post.is_unread?(@enactor) ? t('forum.unread_marker') : " "
      end

      def author(post)
        post.author_name
      end
      
      def date(post)
        post.created_date_str_short(@enactor)
      end
      
      def subject(post)
        pinned = post.is_pinned? ? "*" : ""
        "#{pinned}#{post.subject}"
      end
    end
    
  end
end