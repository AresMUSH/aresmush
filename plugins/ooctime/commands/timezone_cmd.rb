module AresMUSH
  module OOCTime
    class TimezoneCmd
      include CommandHandler
           
      attr_accessor :zone
           
      def parse_args
        self.zone = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.zone ]
      end
      
      def handle
        error = OOCTime.set_timezone(enactor, self.zone)
        if (error)
          client.emit_failure error
        else
          client.emit_success t('time.timezone_set', :timezone => self.zone)
          AresCentral.warn_if_setting_linked_preference(client, enactor)
        end
      end
    end
  end
end
