module AresMUSH
  module Scenes
    class Pemit
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
      
      def log_command
        # Don't log pose details, but do record that someone used the command for abuse
        Global.logger.debug("#{self.class.name}: #{client} Enactor=#{enactor_name} Cmd=pemit")
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |results|
          results.each do |r|
            nospoof = ""            
            if (r.char.pose_nospoof)
              nospoof = "%xc%% #{t('scenes.pemit_nospoof_from', :name => enactor_name)}%xn%R"
            end
            r.client.emit "#{r.char.pose_autospace}#{nospoof}#{self.message}"
          end
        end
      end
    end
  end
end
