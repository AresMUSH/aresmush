module AresMUSH
  module Forum
    class ForumIndexTemplate < ErbTemplateRenderer
      
      attr_accessor :categories
      
      def initialize(char)
        @char = char
        @categories = Forum.visible_categories(char)
        @hidden = Forum.hidden_categories(char)
        super File.dirname(__FILE__) + "/index.erb"
      end
      
      def num(index)
        "#{index+1}"
      end        
      
      def hidden_categories
        @hidden.map { |h| "#{h.category_index}-#{h.name}" }.join(' ')
      end
      
      def any_hidden?
        @hidden.count > 0
      end
      
      # Shows whether the character has read or write permissions
      # to the category. (e.g. rw or r-)
      def permission(category)
        read_status = Forum.can_read_category?(@char, category) ? "r" : "-"
        write_status = Forum.can_write_to_category?(@char, category) ? "w" : "-"
        "#{read_status}#{write_status}"
      end
      
      # Shows the unread marker if there are posts the character hasn't read.
      def unread(category)
        category.has_unread?(@char) ? t('forum.unread_marker') : " "
      end
    end
  end
end