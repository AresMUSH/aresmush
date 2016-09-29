module AresMUSH
  module Cookies
    class CookieCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :names
      
      def initialize(client, cmd, enactor)
        self.required_args = ['names']
        self.help_topic = 'cookies'
        super
      end
      
      def crack!
        if (!cmd.args)
          self.names = []
        else
          self.names = cmd.args.split(" ")
        end
      end
      
      def handle
        names.each do |name|
          result = ClassTargetFinder.find(name, Character, client)
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
