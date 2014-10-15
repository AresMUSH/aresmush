module AresMUSH
  module Api
    class PingCmdHandler < ApiCommandHandler
      
      def handle
        chars = []
        Global.client_monitor.logged_in_clients.each do |c|
          chars << "#{c.name}:#{c.char.handle}"
        end
        args = ApiPingResponseArgs.new(chars)
        cmd.create_response(ApiResponse.ok_status, args.to_s)
      end
    end
  end
end