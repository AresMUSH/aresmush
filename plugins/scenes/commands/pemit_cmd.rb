module AresMUSH
  module Scenes
    class PemitCmd
      include CommandHandler
      
      attr_accessor :names, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.names = list_arg(args.arg1)
        self.message = args.arg2
      end
      
      def required_args
        [ self.names, self.message ]
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |results|
          results.each do |r|
            nospoof = "%xc%% #{t('scenes.pemit_nospoof_from', :name => enactor_name)}%xn%R"
            r.client.emit "#{r.char.pose_autospace}#{nospoof}#{self.message}"
          end
        end
      end
    end
  end
end
