module AresMUSH
  module Login
    class WatchCmd
      include CommandHandler
      
      attr_accessor :option

      def parse_args
        self.option = !cmd.args ? nil : cmd.args.downcase
      end

      def required_args
        {
          args: [ self.option ],
          help: 'watch'
        }
      end
      
      def check_option
        return nil if self.option == 'all' || self.option == 'none' || self.option == 'friends'
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
        end
      end
    end
  end
end
