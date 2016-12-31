module AresMUSH
  module Cookies
    class CookieCmd
      include CommandHandler
           
      attr_accessor :names
      
      def crack!
        if (!cmd.args)
          self.names = []
        else
          self.names = cmd.args.split(" ")
        end
      end
      
      def required_args
        {
          args: [ self.names ],
          help: 'cookies'
        }
      end
      
      def handle
        names.each do |name|
          result = ClassTargetFinder.find(name, Character, enactor)
          if (!result.found?)
            client.emit_failure(t('cookies.invalid_recipient', :name => name))
          else
            Cookies.give_cookie(result.target, client, enactor)
          end
        end
      end
    end
  end
end
