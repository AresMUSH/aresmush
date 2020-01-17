module AresMUSH
  
  module Website
    
    module WikiMarkdownExtensions
      
      def self.preprocess_tags
        [
          WikidotExternalLinkMarkdownExtension,
          WikidotInternalLinkMarkdownExtension,
          IncludeMarkdownExtension,
          WikidotHeading,
          WikidotAnchor,
          WikidotCenter,
          ImageMarkdownExtension,
          WikidotEndCenter,
          WikidotHtml,
          SpeechBracketExtension,
          StartPreBlockMarkdownExtension,
          EndPreBlockMarkdownExtension
          
        ]
      end
      
      def self.postprocess_tags
        [
          # Most of these are post tags because otherwise the text inside them ends up 
          # beng marked as HTML instead of markdown.
          
          WikidotItalics,
          CharacterGalleryMarkdownExtension,
          MusicPlayerMarkdownExtension,
          SpotifyMarkdownExtension,
          YoutubeMarkdownExtension,
          PinterestMarkdownExtension,
          StartCollapsibleMarkdownExtension,
          EndCollapsibleMarkdownExtension,
          PageListMarkdownExtension,
          CategoryListMarkdownExtension,
          SceneListMarkdownExtension,
          StartDivBlockMarkdownExtension,
          StartSpanBlockMarkdownExtension,
          EndDivBlockMarkdownExtension,
          EndSpanBlockMarkdownExtension,

        ]
      end
      
      def self.is_dynamic_page?(page_text)
        page_text =~ /(\[\[scenelist)|(\[\[chargallery)|(\[\[pagelist)/i
      end
    end
    
  end
end