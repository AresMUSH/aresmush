module AresMUSH
  class Dispatcher

    # Places a new command in the queue to be processed.
    def queue_command(client, cmd)
      EventMachine.next_tick { on_command(client, cmd) } 
    end
    
    # Place a new event in the queue to be processed.
    def queue_event(event)
      EventMachine.next_tick { on_event(event) } 
    end
    
    # Place an action in the queue to be run after APPROXIMATELY the specified number of seconds.
    # The dispatcher is not a precise timer.
    def queue_timer(seconds, description, client, &block)
      EventMachine.add_timer(seconds) do 
        AresMUSH.with_error_handling(client, description) do   
          yield block
        end
      end
    end

    # Spawns a separate task to handle something in the background while doing other things.
    # This is good for rendering templates and doing file IO.   USE CAUTION to make sure the code
    # called by your action is thread-safe.   You can set a callback method that will be triggered
    # with the return value of the block.
    #
    # For example, this will emit "Task complete!" after doing the long task.
    #
    #     callback = Proc.new { |text| client.emit text }
    #     Global.dispatcher.spawn("Doing something", client, callback) do
    #         do_some_long_task
    #         "Task complete!"
    #     end
    def spawn(description, client, callback = nil, &block)
      EventMachine.defer do
        AresMUSH.with_error_handling(client, description) do   
          return_val = yield block
          callback.call return_val if callback
        end
      end
    end
    
    ### IMPORTANT!!!  Do not call from outside of the dispatcher.
    ### Use queue_command if you need to queue up a command to process
    def on_command(client, cmd)
      @handled = false
      with_error_handling(client, cmd) do
        CommandAliasParser.substitute_aliases(client, cmd)
        Global.plugin_manager.plugins.each do |p|
          with_error_handling(client, cmd) do
            begin
              wants_command = p.want_command?(client, cmd)
            rescue Exception => e
              Global.logger.error("Bad wants_command method in #{p}: error=#{e} backtrace=#{e.backtrace[0,10]}")
              wants_command = false
            end
            
            if (wants_command)
              p.on_command(client, cmd)
              return
            end # if
          end # with error handling
        end # each
        if (!@handled)
          Global.logger.info("Unrecognized command: #{cmd}")
          client.emit_ooc t('dispatcher.huh')
        end
      end # with error handling
    end

    ### IMPORTANT!!!  Do not call from outside of the dispatcher.
    ### Use queue_event if you need to queue up an event
    def on_event(event)
      begin
        event_handler_name = "on_#{event.class.name.split('::').last.underscore}"
        Global.plugin_manager.plugins.each do |s|
          
          if (s.respond_to?(:"#{event_handler_name}"))
            s.send(:"#{event_handler_name}", event)
          end
        end
      rescue Exception => e
        Global.logger.error("Error handling event: event=#{event} error=#{e} backtrace=#{e.backtrace[0,10]}")
      end
    end
    
    private
    
    def with_error_handling(client, cmd, &block)
      return_val = AresMUSH.with_error_handling(client, "Command #{cmd.raw}", &block)
      if (!return_val)
        @handled = true
      end
    end
  end
end