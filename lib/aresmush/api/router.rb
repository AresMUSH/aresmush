module AresMUSH
  module Api
    class ApiRouter
      
      attr_accessor :cmd_handlers, :response_handlers
      
      def initialize
        find_handlers
      end
      
      def find_handlers
        self.cmd_handlers = {}
        self.response_handlers = {}
        load_from_module(AresMUSH)
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
          handler_class = NoOpResponseHandler
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
                if (Api.is_master? && sym.available_on_master? ||
                    !Api.is_master? && sym.available_on_slave? )
                  self.cmd_handlers[cmd] = sym
                end
              end
            elsif (sym.include?(AresMUSH::ApiResponseHandler))
              sym.commands.each do |cmd|
                if (Api.is_master? && sym.available_on_master? ||
                    !Api.is_master? && sym.available_on_slave? )
                  self.response_handlers[cmd] = sym
                end
              end
            end
          end
        end
      end
    end
  end
end