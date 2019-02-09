module AresMUSH
  module Cookies
    class CookieCmd
      include CommandHandler
           
      attr_accessor :names
      
      def parse_args
        if (!cmd.args)
          self.names = []
        else
          self.names = cmd.args.split(" ")
        end
      end
      
      def handle
        names.each do |name|
          result = ClassTargetFinder.find(name, Character, enactor)
          if (!result.found?)
            client.emit_failure(t('cookies.invalid_recipient', :name => name))
          else
            error = Cookies.give_cookie(result.target, enactor)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('cookies.cookie_given', :name => name)
            end
          end
        end
      end
    end
  end
end

