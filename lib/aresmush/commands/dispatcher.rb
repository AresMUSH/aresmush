module AresMUSH
  class Dispatcher

    # Places a new command in the queue to be processed.
    def queue_command(client, cmd)
      EventMachine.defer do
        AresMUSH.with_error_handling(client, "Queue command.") do
          on_command(client, cmd)
        end
      end
    end
    
    # Place a new event in the queue to be processed.
    def queue_event(event)
      EventMachine.defer do
        AresMUSH.with_error_handling(nil, "Queue event.") do
          on_event(event)
        end
      end
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
    
    # Places a new action in the queue to be processed.
    def queue_action(client, &block)
      EventMachine.next_tick do
        AresMUSH.with_error_handling(client, "Queue action.") do
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
    
    def temp_dispatch(client, cmd)
      Global.plugin_manager.plugins.each do |p|
        consts = p.constants
        consts.each do |c|
          sym = p.const_get(c)
          if (sym.class == Class && sym.include?(AresMUSH::CommandHandler))
            klass = sym.new
            if (klass.want_command?(client, cmd))
              Global.logger.debug "Found #{sym}."
              klass.on_command(client, cmd)
              return true
            end
          end
        end
      end
      return false      
    end
    
    ### IMPORTANT!!!  Do not call from outside of the dispatcher.
    ### Use queue_command if you need to queue up a command to process
    def on_command(client, cmd)
      @handled = false
      client.reload
      with_error_handling(client, cmd) do
        CommandAliasParser.substitute_aliases(client, cmd, Global.plugin_manager.shortcuts)
        Global.plugin_manager.plugins.each do |p|
          with_error_handling(client, cmd) do
            wanted = p.handle_command(client, cmd)
            if (wanted)
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
        Global.plugin_manager.plugins.each do |p|
          AresMUSH.with_error_handling(nil, "Handling #{event}.") do
            handled = p.handle_event(event)
            if (handled)
              return
            end # if
          end # with error handling
        end # each
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