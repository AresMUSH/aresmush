module AresMUSH
  module Login
    class KeepaliveSetCmd
      include CommandHandler

      attr_accessor :option

      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'keepalive'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(login_keepalive: self.option.is_on?)
        client.emit_success t('login.keepalive_set', :option => self.option)
      end
    end
  end
end