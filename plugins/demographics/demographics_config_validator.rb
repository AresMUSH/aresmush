module AresMUSH
  module Demographics
    class DemographicsConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("demographics")
      end
      
      def validate
        @validator.require_list('demographics')
        @validator.require_boolean('disable_auto_shortcuts')
        @validator.require_hash('help_text')
        @validator.require_int('max_age')
        @validator.require_int('min_age', 0)
        @validator.require_text('nickname_field')
        @validator.require_text('nickname_format')
        @validator.require_list('editable_properties')
        @validator.require_list('private_properties')
        @validator.require_list('required_properties')
        @validator.require_list("census_fields")
        @validator.require_hash("groups")
        @validator.require_hash("genders")

        begin
          nick_field = Global.read_config('demographics', 'nickname_field')
          if (!nick_field.blank? && !Demographics.all_demographics.include?(nick_field))
            @validator.add_error "demographics:nickname_field is not a valid demographic."
          end
          check_census
          check_demographic_list('editable_properties')
          check_demographic_list('private_properties')
          check_demographic_list('required_properties')
                
          Global.read_config("demographics", "genders").each do |k, v|
            check_gender(k, v)
          end
        
          Global.read_config("demographics", "groups").each do |k, v|
            if (v['values'] && !v['values'].kind_of?(Hash))
              @validator.add_error "demographics:groups:#{k} values must be a hash."
            end
          end
        rescue Exception => ex
          @validator.add_error "Unknown demographic config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
      
      def check_demographic_list(field)
        Global.read_config("demographics", field).each do |prop|
          if (!Demographics.all_demographics.include?(prop))
            @validator.add_error "demographics:#{field} #{prop} is not a valid demographic."
          end
        end
      end
      
      def check_gender(name, gender)
        if (!gender['possessive_pronoun'])
          @validator.add_error "demographics:genders:#{name} missing poss. pronoun."
        end
        if (!gender['objective_pronoun'])
          @validator.add_error "demographics:genders:#{name} missing obj. pronoun."
        end
        if (!gender['subjective_pronoun'])
          @validator.add_error "demographics:genders:#{name} missing sub. pronoun."
        end
        if (!gender['noun'])
          @validator.add_error "demographics:genders:#{name} missing noun."
        end
      end
      
      def check_census
        census = Global.read_config("demographics", "census_fields")
        errors = Profile.validate_general_field_config(census)
        errors.each do |e|
          @validator.add_error "demographics:census_fields #{e}"
        end
      end
    end
  end
end