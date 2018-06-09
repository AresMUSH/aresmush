module AresMUSH
  module Login
    class NoticesCmd
      include CommandHandler

      attr_accessor :option
      
      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        [ self.option ]
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        is_on = self.option.is_on?
        case cmd.switch
        when "events"
          enactor.update(notices_events: is_on)
        else
          client.emit_failure t('login.unrecognized_notice_config')
          return
        end
          
        if (is_on)
          client.emit_success t('login.notice_config_on', :config => cmd.switch.titleize)
        else
          client.emit_success t('login.notice_config_off', :config => cmd.switch.titleize)
        end 
      end
    end
  end
end