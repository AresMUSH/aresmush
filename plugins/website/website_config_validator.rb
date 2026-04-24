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
        @validator.require_boolean('hide_searchbox')
        @validator.require_list("public_wiki_folders")
        @validator.require_text('default_public_folder')
        
        recaptcha = AresMUSH::Website::RecaptchaHelper.new
        turnstile = AresMUSH::Website::TurnstileHelper.new
        if (recaptcha.is_enabled? && turnstile.is_enabled?)
          @validator.add_error "website: Both recaptcha and turnstile are enabled. Please pick one."
        end
        
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
          
          public_folders = Global.read_config("website", "public_wiki_folders") || []
          default_public_folder = Global.read_config("website", "default_public_folder")
          if (!public_folders.include?(default_public_folder))
            @validator.add_error "website:default_public_folder is not one of the public_wiki_folders"
          end
          
        rescue Exception => ex
          @validator.add_error "Unknown website config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
          
        end
        
        @validator.errors
      end

    end
  end
end