module AresMUSH
  module OOCTime
    class TimezoneCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
           
      attr_accessor :zone
           
      def crack!
        self.zone = trim_input(cmd.args)
        handle_timezone_aliases
      end
      
      def required_args
        {
          args: [ self.zone ],
          help: 'time'
        }
      end
      
      def handle_timezone_aliases
        case self.zone.upcase
        when "EST"
          self.zone = "America/New_York"
        when "CST"
          self.zone = "America/Chicago"
        when "MST"
          self.zone = "America/Denver"
        when "PST"
          self.zone = "America/Los_Angeles"
        else
          # Leave timezone alone
        end
      end
        
      def check_timezone
        valid_zones = Timezone::Zone.names
        return t('time.invalid_timezone') if !valid_zones.include?(self.zone)
        return nil
      end
      
      def handle
        enactor.timezone = self.zone
        enactor.save
        client.emit_success t('time.timezone_set', :timezone => self.zone)
        Handles::Api.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
