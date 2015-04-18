module AresMUSH
  class ApiRouter
    attr_accessor :cmd_handlers, :response_handlers, :is_master
      
    def initialize(is_master)
      self.is_master = is_master
      find_handlers
    end
      
    def find_handlers
      self.cmd_handlers = {}
      self.response_handlers = {}
      load_from_module(AresMUSH)
    end
    
    def is_master?
      is_master
    end

    def send_response(client, key, response)
      Global.logger.debug "Sending API response to #{client.id} #{response}."

      encrypted = ApiCrypt.encrypt(key, response.to_s)
      # Use emit raw to avoid tacking extra Ansi codes on.
      client.emit_raw "api< #{encrypted[:iv]} #{encrypted[:data]}\r\n"
    end    
    
    def send_command(destination_id, client, cmd)
      EM.defer do
        success = AresMUSH.with_error_handling(client, "API sending command #{cmd} to #{destination_id}") do
          socket = nil
          begin
            destination = ServerInfo.find_by_dest_id(destination_id)
            raise "Host #{destination_id} not found" if destination.nil?

            host = destination.host
            port = destination.port
            key = destination.key

            Global.logger.debug "Sending API command to #{destination_id} #{host} #{port}: #{cmd}."
      
            Timeout.timeout(4) do
              socket = TCPSocket.new host, port
              encrypted = ApiCrypt.encrypt(key, cmd.to_s)
              sleep 1
              
              socket.puts "api> #{Game.master.api_game_id} #{encrypted[:iv]} #{encrypted[:data]}\r\n"
   
              while (line = socket.gets)
                Global.logger.debug "Got answer from #{host} #{port}: #{line}."
                
                if (line.start_with?("api< "))
                  Global.logger.debug "Recognized it was an API response."
                  
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
    
    def route_command(game_id, cmd)
      handler_class = self.cmd_handlers[cmd.command_name]
        
      if handler_class.nil?
        return cmd.create_error_response t('api.unrecognized_command')
      end
        
      handler = handler_class.new(game_id, cmd)
      error = handler.validate
      if (error)
        return cmd.create_error_response(error)
      end
        
      handler.handle
    end
      
    def route_response(client, response)
      handler_class = self.response_handlers[response.command_name]
      if (handler_class.nil?)
        handler_class = AresMUSH::NoOpResponseHandler
      end
        
      handler = handler_class.new(client, response)
      error = handler.validate
      if (error)
        raise error
      end
        
      handler.handle
    end
      
    private
      
    def load_from_module(mod)
      mod.constants.each do |c|
        sym = mod.const_get(c)
        if (sym.class == Module)
          load_from_module(sym)
        elsif (sym.class == Class)
          if (sym.include?(AresMUSH::ApiCommandHandler))
            sym.commands.each do |cmd|
              if (is_master && sym.available_on_master? ||
                !is_master && sym.available_on_slave? )
                self.cmd_handlers[cmd] = sym
              end
            end
          elsif (sym.include?(AresMUSH::ApiResponseHandler))
            sym.commands.each do |cmd|
              if (is_master && sym.available_on_master? ||
                !is_master && sym.available_on_slave? )
                self.response_handlers[cmd] = sym
              end
            end
          end
        end
      end
    end
  end
end