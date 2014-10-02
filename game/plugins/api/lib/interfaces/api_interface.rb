module AresMUSH
  module Api
    
    def self.send_response(client, key, str)
      encrypted = Api.encrypt(key, str)
      # Use emit raw to avoid tacking extra Ansi codes on.
      client.emit_raw "api< #{encrypted[:iv]} #{encrypted[:data]}\n"
    end    
    
    def self.send_command(destination_id, client, str)
      destination = Api.get_destination(destination_id)
      host = destination.host
      port = destination.port
      key = destination.key
      
      EM.defer do
        AresMUSH.with_error_handling(client, "API #{str}") do
          socket = nil
          begin
            Timeout.timeout(10) do
              socket = TCPSocket.new host, port
              encrypted = Api.encrypt(key, str)
              socket.puts "api> #{destination_id} #{encrypted[:iv]} #{encrypted[:data]}"
                
              while (line = socket.gets)
                if (line.start_with?("api< "))
                  Global.logger.debug "API response from #{host} #{port}."
                  response_str = line.after(" ").chomp
                  response_event = Api.decode_response(client, key, response_str)
                  Global.dispatcher.queue_event response_event
                  break
                end
              end
            end
          rescue Timeout::Error
            Global.logger.error "Timeout error communicating with #{host} #{port}."
            Global.dispatcher.queue_event ApiResponseEvent.new(client, nil, t('api.api_error'))
          rescue OpenSSL::Cipher::CipherError
            Global.logger.error "Cipher error communicating with #{host} #{port}."
            Global.dispatcher.queue_event ApiResponseEvent.new(client, nil, t('api.api_cipher_error'))
          rescue Exception => e
            error_info = "error=#{e} backtrace=#{e.backtrace[0,10]}"
            Global.logger.error "Error communicating with #{host} #{port}: #{error_info}"
            Global.dispatcher.queue_event ApiResponseEvent.new(client, nil, t('api.api_error'))
          end
          socket.close if !socket.nil?
        end
      end
    end
  end
end