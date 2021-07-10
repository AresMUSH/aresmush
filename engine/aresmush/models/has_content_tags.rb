module AresMUSH
  module HasContentTags
    def self.included(base)
      base.send :extend, ClassMethods   
      #base.send :register_data_members
    end
 
    module ClassMethods
      def register_data_members
        before_delete :delete_content_tags
      end
    end
    
    def delete_content_tags
      ContentTag.find_by_model(self).each { |t| t.delete }
    end
    
    def content_tags
      ContentTag.find_by_model(self).map { |t| t.name }
    end
  end
end