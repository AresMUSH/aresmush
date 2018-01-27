module AresMUSH
  module Forum
    class ForumIndexTemplate < ErbTemplateRenderer
      
      attr_accessor :categories
      
      def initialize(char)
        @char = char
        @categories = BbsBoard.all_sorted
        super File.dirname(__FILE__) + "/index.erb"
      end
      
      def num(index)
        "#{index+1}"
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