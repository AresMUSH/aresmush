module AresMUSH
  module Pose
    class Pemit
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :names, :message
      
      def initialize
        self.required_args = ['names', 'message']
        self.help_topic = 'posing'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("pemit")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
        self.message = cmd.args.arg2
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |clients|
          clients.each do |c|
            nospoof = ""
            if (c.char.nospoof)
              nospoof = "%xc%% #{t('pose.pemit_nospoof_from', :name => client.name)}%xn%R"
            end
            c.emit "#{Utils::Interface.autospace(c.char)}#{nospoof}#{self.message}"
          end
        end
      end
    end
  end
end
