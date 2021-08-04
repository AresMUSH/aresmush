module AresMUSH
  module Ranks
    class RanksConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("ranks")
      end
      
      def validate
        @validator.require_nonblank_text('rank_group')
        @validator.require_int('rank_rows', 1)
        @validator.require_in_list('rank_style', ['military', 'basic'])
        @validator.require_hash('ranks')
        
        # Don't worry about the remaining config options if ranks are disabled.
        return [] if !Ranks.is_enabled?
        
        begin
          group = Demographics.get_group(Global.read_config('ranks', 'rank_group'))
          if (!group)
            @validator.add_error "ranks:rank_group is not a valid group."
          end
          specified_groups = Global.read_config('ranks', 'ranks').keys
          available_groups = group['values'].keys
          if (specified_groups.sort != available_groups.sort)
            @validator.add_error "ranks:ranks does not list all group vals for the rank group."
          end
          
        rescue Exception => ex
          @validator.add_error "Unknown ranks config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end

    end
  end
end