module AresMUSH
  module Cookies
    class CookieCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :names
      
      def initialize
        self.required_args = ['names']
        self.help_topic = 'cookies'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("cookie") && cmd.switch.nil? && cmd.args
      end
      
      def crack!
        if (cmd.args.nil?)
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
            Cookies.give_cookie(result.target, client)
          end
        end
      end
    end
  end
end
