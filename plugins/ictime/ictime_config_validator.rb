module AresMUSH
  module ICTime
    class ICTimeConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("ictime")
      end
      
      def validate
        @validator.require_list('day_names')
        @validator.require_list('month_names')
        @validator.require_int('day_offset')
        @validator.require_int('hour_offset')
        @validator.require_text('game_start_date')
        @validator.require_int('year_offset')
        
        begin
          ratio = Global.read_config("ictime", "time_ratio")
          start_date = Global.read_config("ictime", "game_start_date")
          if (ratio && ratio != 1 && start_date.blank?)
            @validator.add_error "ictime:game_start_date Can't specify time ratio without a start date."
          end
          if (!start_date.blank?)
            begin
              start = DateTime.strptime(start_date, "%m/%d/%Y")
            rescue
              @validator.add_error "ictime:start_date must be in mm/dd/yyyy format."
            end
          end
          
          day_names = Global.read_config('ictime', 'day_names')
          if (day_names.count > 0 && day_names.count != 7)
            @validator.add_error "ictime:day_names You need 7 custom day names."
          end
          month_names = Global.read_config('ictime', 'month_names')
          if (month_names.count > 0 && month_names.count != 12)
            @validator.add_error "ictime:month_names You need 12 custom month names."
          end
          ratio = Global.read_config('ictime', 'time_ratio')
          if (!ratio.kind_of?(Integer) && !ratio.kind_of?(Float))
            @validator.add_error "ictime:time_ratio must be a number."
          end

        rescue Exception => ex
          @validator.add_error "Unknown ictime config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
    end
  end
end