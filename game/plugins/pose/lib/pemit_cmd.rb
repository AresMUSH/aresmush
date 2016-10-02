module AresMUSH
  module Pose
    class Pemit
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :names, :message
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.names = !cmd.args.arg1 ? [] : cmd.args.arg1.split(" ")
        self.message = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.names, self.message ],
          help: 'posing'
        }
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |results|
          results.each do |r|
            nospoof = ""
            if (r.char.nospoof)
              nospoof = "%xc%% #{t('pose.pemit_nospoof_from', :name => enactor_name)}%xn%R"
            end
            r.client.emit "#{Pose::Api.autospace(r.char)}#{nospoof}#{self.message}"
          end
        end
      end
    end
  end
end
