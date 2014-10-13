module AresMUSH
  module Api
    
    def self.send_response(client, key, response)
      Global.logger.debug "Sending API response to #{client.id} #{response}."

      encrypted = ApiCrypt.encrypt(key, response.response_string)
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
      
            Timeout.timeout(15) do
              socket = TCPSocket.new host, port
              encrypted = ApiCrypt.encrypt(key, cmd.command_string)
              sleep 1
              
              socket.puts "api> #{Game.master.api_game_id} #{encrypted[:iv]} #{encrypted[:data]}\r\n"
   
              while (line = socket.gets)
                if (line.start_with?("api< "))
                  Global.logger.debug "Got API response from #{host} #{port}: #{line}."
                  response_str = line.after(" ").chomp
                  response = ApiCrypt.decode_response(key, response_str)
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
            response = ApiResponse.create_error_response.new(cmd, "Error communicating with remote server.  Please try again later.")
            Global.dispatcher.queue_event ApiResponseEvent.new(client, response)
          end
        end
      end
    end
  end
end