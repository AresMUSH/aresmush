module AresMUSH
  class Dispatcher
    attr_accessor :queue_log
    
    def initialize
      self.queue_log = {}
    end
    
    # Places a new command in the queue to be processed.
    def queue_command(client, cmd)
    
      queue = (self.queue_log[client.id] || []).select { |t| Time.now - t < 1 }
      queue << Time.now
      self.queue_log[client.id] = queue
      queue_limit = Global.read_config('plugins', 'command_queue_limit') || 15
      if (queue.count > queue_limit)
        Global.logger.warn "Command queue overflow from #{client.id}."
        return
      end
      
      EventMachine.next_tick do
        AresMUSH.with_error_handling(client, "Queue command.") do
          on_command(client, cmd)
        end
      end
    end
    
    # Place a new event in the queue to be processed.
    def queue_event(event)
      EventMachine.next_tick do
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
    
    ### IMPORTANT!!!  Do not call from outside of the dispatcher.
    ### Use queue_command if you need to queue up a command to process
    # @engineinternal true
    def on_command(client, cmd)
      @handled = false
      with_error_handling(client, cmd) do
        enactor = client.char
        
        if (enactor && enactor.is_statue?)
          client.emit_failure t('dispatcher.you_are_statue')
          return
        end
        
        CommandAliasParser.substitute_aliases(enactor, cmd, Global.plugin_manager.shortcuts)
        Global.plugin_manager.sorted_plugins.each do |p|
          next if !p.respond_to?(:get_cmd_handler)
          AresMUSH.with_error_handling(client, cmd) do
            handler_class = p.get_cmd_handler(client, cmd, enactor)
            if (handler_class)
              @handled = true
              handler = handler_class.new(client, cmd, enactor)
              handler.on_command
              return
            end # if
          end # with error handling
        end # each
        if (!@handled)
          trimmed_cmd = (cmd.raw || "")[0,25]
          client.emit_ooc t('dispatcher.huh', :command => trimmed_cmd)
        end
      end # with error handling
    end

    ### IMPORTANT!!!  Do not call from outside of the dispatcher.
    ### Use queue_event if you need to queue up an event
    # @engineinternal true
    def on_event(event)
      begin
        event_name = event.class.to_s.gsub("AresMUSH::", "")
        Global.plugin_manager.sorted_plugins.each do |p|
          next if !p.respond_to?(:get_event_handler)
          AresMUSH.with_error_handling(nil, "Handling #{event_name}.") do            
            handler_class = p.get_event_handler(event_name)
            if (handler_class)
              if (event_name != "CronEvent" && event_name != "ConnectionEstablishedEvent" && event_name != "PoseEvent")
                Global.logger.debug "#{handler_class} handling #{event_name}."
              end
              handler = handler_class.new
              handler.on_event(event)
            end # if
          end # with error handling
        end # each
      rescue Exception => e
        Global.logger.error("Error handling event: event=#{event} error=#{e} backtrace=#{e.backtrace[0,10]}")
      end
    end

    ### IMPORTANT!!!  Do not call from outside of the event machine reactor loop!
    # @engineinternal true
    def on_web_request(request)
      handled = false
      AresMUSH.with_error_handling(nil, "Web Request") do
        Global.plugin_manager.sorted_plugins.each do |p|
          next if !p.respond_to?(:get_web_request_handler)
          handler_class = p.get_web_request_handler(request)
          if (handler_class)
            handled = true
            handler = handler_class.new
            return handler.handle(request)
          end # if
        end # each
      end # with error handling
      Global.logger.error("Unhandled web request: #{request.json}.")
      return { error: "Oops!  Something went wrong when the website talked to the game.  Please try again and alert staff is the problem persists." }
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