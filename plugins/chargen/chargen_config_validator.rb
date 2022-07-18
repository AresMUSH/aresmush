module AresMUSH
  module Chargen
    class ChargenConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("chargen")
      end
      
      def validate
        @validator.require_boolean("allow_web_submit")
        @validator.require_in_list("app_category", Jobs.categories)
        @validator.require_in_list("app_hold_status", Jobs.status_vals)
        @validator.require_in_list("app_resubmit_status", Jobs.status_vals)
        @validator.require_list("app_review_commands")
        @validator.require_text("approval_message")
        @validator.require_text("bg_blurb")
        @validator.require_text("demographics_blurb")
        @validator.require_text("desc_blurb")
        @validator.require_text("groups_blurb")
        @validator.require_text("hooks_blurb")
        @validator.require_boolean("hooks_required")
        @validator.require_text("icon_blurb")
        @validator.require_text("lastwill_blurb")
        @validator.require_text("post_approval_message")
        @validator.require_text("rank_blurb")
        @validator.require_text("rejection_message")
        @validator.require_text("welcome_message")
        @validator.require_hash("stages")
        @validator.check_forum_exists("arrivals_category")
        
        begin
          check_stages
        rescue Exception => ex
          @validator.add_error "Unknown chargen config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
      
      def check_stages
        stages = Global.read_config("chargen", "stages")
        return if (!stages.kind_of?(Hash))
        
        stages.each do |stage, keys|
          if (!(keys.include?('help') || keys.include?('text')))
            @validator.add_error("chargen stage #{stage} must have either a help reference or some text.")
          end
          if (keys.include?('help'))
            begin
              Help.get_help(keys['help'])
            rescue
              @validator.add_error("chargen stage #{stage} help file #{keys['help']} not found.")
            end
          end
        end
      end      
    end
  end
end