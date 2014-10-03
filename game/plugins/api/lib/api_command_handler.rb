module AresMUSH
  module Api
    class ApiCommandHandler
      include Plugin
           
      attr_accessor :game_id, :cipher_iv, :encrypted_data
      
      def initialize
        Api.create_router
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("api>")
      end
      
      def crack!
        cmd.crack_args!(/(?<game_id>[\S]+) (?<cipher_iv>[\S]+) (?<data>.+)/)
        
        self.game_id = cmd.args.game_id
        self.cipher_iv = cmd.args.cipher_iv
        self.encrypted_data = cmd.args.data
      end
      
      def handle
        AresMUSH.with_error_handling(nil, "API Response #{self.game_id}") do
          begin
            key = Api.get_destination(self.game_id).key
            command_str = Api.decrypt(key, self.cipher_iv, self.encrypted_data)
            response = Api.router.route_command(self.game_id, command_str)
            Api.send_response client, key, "api< #{response}"
          rescue Exception => e
            error_info = "error=#{e} backtrace=#{e.backtrace[0,10]}"
            Global.logger.error "Error receiving command from #{game_id} #{command_str}: #{error_info}"
            Api.send_response client, key, "api< #{t('api.api_error')}"
          end
        end
      end
    end
  end
end