module AresMUSH
  module OOCTime
    class TimezoneCmd
      include CommandHandler
           
      attr_accessor :zone
           
      def parse_args
        self.zone = trim_arg(cmd.args)
        handle_timezone_aliases
      end
      
      def required_args
        {
          args: [ self.zone ],
          help: 'time'
        }
      end
      
      def handle_timezone_aliases
        case self.zone ? self.zone.upcase : nil
        when "EST"
          self.zone = "America/New_York"
        when "CST"
          self.zone = "America/Chicago"
        when "MST"
          self.zone = "America/Denver"
        when "PST"
          self.zone = "America/Los_Angeles"
        when "AST"
          self.zone = "Canada/Atlantic"
        when "GMT"
          self.zone = "Greenwich"
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
        enactor.update(ooctime_timezone: self.zone)
        client.emit_success t('time.timezone_set', :timezone => self.zone)
        AresCentral.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
