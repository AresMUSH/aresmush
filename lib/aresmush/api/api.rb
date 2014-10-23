module AresMUSH
  module Api
    mattr_accessor :router
    
    def self.get_character_id(client)
      if (Api.is_master?)
        client.emit_failure t('api.cant_link_on_master')
      else
        client.emit_success t('api.character_id_is', :id => client.char.api_character_id)
      end
    end
    
    def self.create_router
      if (Api.is_master?)
        self.router = ApiMasterRouter.new
      else
        self.router = ApiSlaveRouter.new
      end
    end
    
    def self.is_master?
      game = Game.master
      game.nil? ? false : Game.master.api_game_id == ServerInfo.arescentral_game_id
    end
    
    def self.get_destination(dest_id)
      ServerInfo.where(game_id: dest_id).first
    end
    
    def self.random_link_code
      (0...8).map { (65 + rand(26)).chr }.join
    end
    
    def self.send_response(client, key, response)
      Global.logger.debug "Sending API response to #{client.id} #{response}."

      encrypted = ApiCrypt.encrypt(key, response.to_s)
      # Use emit raw to avoid tacking extra Ansi codes on.
      client.emit_raw "api< #{encrypted[:iv]} #{encrypted[:data]}\n"
    end    
    
    def self.send_command(destination_id, client, cmd)
      EM.defer do
        success = AresMUSH.with_error_handling(client, "API sending command #{cmd} to #{destination_id}") do
          socket = nil
          begin
            destination = Api.get_destination(destination_id)
            raise "Host #{destination_id} not found" if destination.nil?

            host = destination.host
            port = destination.port
            key = destination.key

            Global.logger.debug "Sending API command to #{destination_id} #{host} #{port}: #{cmd}."
      
            Timeout.timeout(10) do
              socket = TCPSocket.new host, port
              encrypted = ApiCrypt.encrypt(key, cmd.to_s)
              sleep 1
              
              socket.puts "api> #{Game.master.api_game_id} #{encrypted[:iv]} #{encrypted[:data]}\r\n"
   
              while (line = socket.gets)
                if (line.start_with?("api< "))
                  response_str = line.after(" ").chomp
                  response = ApiCrypt.decode_response(key, response_str)
                  Global.logger.debug "Got API response from #{host} #{port}: #{response}."
                  if (response.command_name != cmd.command_name)
                    raise "Unexpected command response: #{response.command_name} to #{cmd.command_name}."
                  end
                  
                  Global.dispatcher.queue_event ApiResponseEvent.new(client, response)
                  break
                end
              end
            end
          rescue Timeout::Error
            raise "Timeout error communicating with #{host} #{port}."
          rescue OpenSSL::Cipher::CipherError
            raise "Authentication error communicating with #{host} #{port}."
          ensure
            socket.close unless socket.nil?
          end
        end # with error handling
        begin
          if (!success)
            response = cmd.create_error_response(t('api.api_error'))
            Global.dispatcher.queue_event ApiResponseEvent.new(client, response)
          end
        rescue Exception => e
          Global.logger.error "Error raising api error event: #{e} #{e.backtrace[0,10]}"
        end
      end
    end
  end
end