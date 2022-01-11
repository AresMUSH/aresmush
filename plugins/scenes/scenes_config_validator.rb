module AresMUSH
  module Scenes
    class ScenesConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("scenes")
      end
      
      def validate
        @validator.require_boolean('delete_unshared_scenes')
        @validator.require_int('idle_scene_timeout_days', 1)
        @validator.require_boolean('include_pose_separator')
        @validator.require_text('ooc_color')
        @validator.require_int('related_scenes_filter_days', 1, 365)
        @validator.check_cron('room_cleanup_cron')
        @validator.require_list('scene_types')
        @validator.check_cron('trending_scenes_cron')
        @validator.check_cron('unshared_scene_cleanup_cron')
        @validator.require_int('unshared_scene_deletion_days', 1)
        @validator.require_int('unshared_scene_warning_days', 1)
        @validator.require_boolean('use_custom_char_cards')
        
        begin
          if (Global.read_config('scenes', 'unshared_scene_warning_days') >=
              Global.read_config('scenes', 'unshared_scene_deletion_days'))
            @validator.add_error "Unshared scene warning needs to be before the delete timeout."
          end
          @validator.check_forum_exists('trending_scenes_category')
        rescue Exception => ex
          @validator.add_error "Unknown scenes config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end

    end
  end
end