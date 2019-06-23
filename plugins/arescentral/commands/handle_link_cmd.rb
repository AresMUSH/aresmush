module AresMUSH
  module AresCentral
    class HandleLinkCmd
      include CommandHandler
      
      attr_accessor :handle_name, :link_code

      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.handle_name = titlecase_arg(args.arg1)
        self.link_code = trim_arg(args.arg2)
      end

      def required_args
        [ self.handle_name, self.link_code ]
      end
      
      def check_guest
        return t('dispatcher.not_allowed') if (enactor.is_guest?)
        return nil
      end
      
      def check_handle_name
        return t('arescentral.character_already_linked') if enactor.handle
        return nil
      end
      
      def handle
        error = AresCentral.link_handle(enactor, self.handle_name, self.link_code)
        if (error)
          client.emit_failure error
        else
          client.emit_success t('arescentral.link_successful', :handle => self.handle_name)
        end     
      end      
    end

  end
end
