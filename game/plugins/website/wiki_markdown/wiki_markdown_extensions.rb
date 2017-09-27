module AresMUSH
  
  module Website
    
    module WikiMarkdownExtensions
      
      def self.preprocess_tags
        [
          WikidotExternalLinkMarkdownExtension
        ]
      end
      
      def self.postprocess_tags
        [
          StartDivBlockMarkdownExtension,
          EndDivBlockMarkdownExtension,
          StartSpanBlockMarkdownExtension,
          EndSpanBlockMarkdownExtension,
          WikidotItalics,
          WikidotInternalLinkMarkdownExtension,
          CharacterGalleryMarkdownExtension,
          ImageMarkdownExtension,
          IncludeMarkdownExtension,
          MusicPlayerMarkdownExtension,
          PageListMarkdownExtension,
          SceneListMarkdownExtension
        ]
      end
      
    end
    
  end
end