module AresMUSH
  module Login
    class WatchCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = !cmd.args ? nil : cmd.args.downcase
      end

      def required_args
        [ self.option ]
      end
      
      def check_option
        options = [ 'all', 'none', 'friends', 'new' ]
        return nil if options.include?(self.option)
        t('login.invalid_watch_option')
      end
      
      def handle
        enactor.update(login_watch: self.option)
        if (self.option == "all")
          client.emit_success t('login.watch_all')
        elsif (self.option == "none")
          client.emit_success t('login.watch_none')
        elsif (self.option == "friends")
          client.emit_success t('login.watch_friends')
        elsif (self.option == 'new')
          client.emit_success t('login.watch_new')
        end
      end
    end
  end
end
