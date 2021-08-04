module AresMUSH
  module Website
    class WebsiteConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("website")
      end
      
      def validate
        @validator.require_boolean('allow_html_in_markdown')
        @validator.require_nonblank_text('character_gallery_group')
        @validator.require_text('character_gallery_subgroup')
        @validator.require_boolean('left_sidebar')
        @validator.require_int('max_folder_size_kb', 0)
        @validator.require_int('max_upload_size_kb', 0)
        @validator.require_list('restricted_pages')
        @validator.check_cron('sitemap_update_cron')
        @validator.require_list('top_navbar')
        @validator.require_nonblank_text('website_code_path')
        @validator.require_hash('wiki_aliases')
        
        begin
          gallery_group = Global.read_config('website', 'character_gallery_group')
          group = Demographics.get_group(gallery_group)
          if (!group)
            @validator.add_error "website:character_gallery_group #{gallery_group} is not a valid group."
          end
          
          gallery_subgroup = Global.read_config('website', 'character_gallery_subgroup')
          group = Demographics.get_group(gallery_subgroup)
          if (!gallery_subgroup.blank? && !group)
            @validator.add_error "website:character_gallery_subgroup #{gallery_subgroup} is not a valid group."
          end
          
        rescue Exception => ex
          @validator.add_error "Unknown website config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
          
        end
        
        @validator.errors
      end

    end
  end
end