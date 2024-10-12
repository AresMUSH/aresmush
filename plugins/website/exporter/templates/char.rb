module AresMUSH
  module Website
    class WikiExportCharTemplate < ErbTemplateRenderer
            
      attr_accessor :char, :scene_block, :demographics_and_groups, :fs3_data
      
      def initialize(char, scene_block)
        @char = char
        @scene_block = scene_block
        if (self.fs3skills_enabled)
          @fs3_data = FS3Skills.build_web_char_data(@char, @char)
        end
        @demographics_and_groups = Demographics.build_web_profile_data(@char, @char)
        
        super File.dirname(__FILE__) + "/char.erb"
      end
      
      def title
        Profile.profile_title(@char)
      end
      
      def demographics
        @demographics_and_groups[:demographics]
      end
      
      def groups
        @demographics_and_groups[:groups]
      end
      
      def profile
         Profile.build_profile_sections_web_data(@char)
       end
       
       def relationships
         Profile.build_profile_relationship_web_data(@char)
       end
       
       def rp_hooks
         Website.format_markdown_for_html(@char.rp_hooks)
       end
       
       def show_bg
         @char.on_roster? || @char.bg_shared
       end
       
       def background
         Website.format_markdown_for_html(@char.background)
       end
       
       def desc
         Website.format_markdown_for_html(@char.description)
       end
       
       def details
         @char.details.map { |name, desc| "<b>#{name}</b> - #{Website.format_markdown_for_html(desc)}" }
       end
       
       def gallery
         Profile.character_gallery_files(@char).map { |g| g.start_with?("/") ? g.after('/') : g }
       end
       
       def achievements
         Achievements.build_web_profile_data(@char, @char)[:achievements]
       end
       
       def fs3skills_enabled
         FS3Skills.is_enabled?
       end 
       
       def fs3combat_enabled
         FS3Combat.is_enabled?
       end 
       
       def damage
         @char.damage.sort { |d| d.created_at }
           .map { |d| "#{d.ictime_str} - #{AnsiFormatter.strip_ansi(MushFormatter.format(FS3Combat.display_severity(d.initial_severity)))} - #{d.description}" }
       end           
    end
  end
end