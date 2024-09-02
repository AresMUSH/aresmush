module AresMUSH
  module Website
    
    # NOTE! The actual processing is handled by MarkdownFinalizer
    
    class ImageGalleryExtensionTemplate < ErbTemplateRenderer
             
      attr_accessor :gallery
                     
      def initialize(gallery)
        @gallery = gallery
        super File.dirname(__FILE__) + "/image_gallery.erb"        
      end      
    end
    
  end
end
