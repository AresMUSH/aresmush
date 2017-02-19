module AresMUSH
  module Demographics
  
    class DemographicAdminCmd
      include CommandHandler
  
      attr_accessor :name, :value, :property

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2_equals_arg3)
        self.name = titlecase_arg(args.arg1)
        self.property = downcase_arg(args.arg2)
        self.value = titlecase_arg(args.arg3)
      end
  
      def required_args
        {
          args: [ self.name, self.property, self.value ],
          help: 'demographics'
        }
      end
     
      def check_is_allowed
        return t('dispatcher.not_allowed') if !Demographics.can_set_demographics?(enactor)
        return nil
      end

      def check_property
        return t('demographics.set_birhdate_instead') if (self.property == "age")
        return t('demographics.invalid_demographic') if !DemographicInfo.new.respond_to?("#{self.property}=")
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          demographics = model.get_or_create_demographics
          if (self.property == "birthdate")
            begin
              self.value = Date.strptime(self.value, Global.read_config("date_and_time", "short_date_format"))
            rescue
              client.emit_failure t('demographics.invalid_birthdate', 
                :format_str => Global.read_config("date_and_time", "date_entry_format_help"))
              return
            end
          end
          demographics.send("#{self.property}=", self.value)
          demographics.save
          client.emit_success t('demographics.admin_property_set', :name => self.name, :property => self.property, :value => self.value)
        end
      end
    end
  end
end