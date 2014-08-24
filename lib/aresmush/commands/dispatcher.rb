module AresMUSH
  class Dispatcher

    def queue_command(client, cmd)
      EventMachine.next_tick { on_command(client, cmd) } 
    end
    
    def queue_event(event)
      EventMachine.next_tick { on_event(event) } 
    end
    
    def queue_timer(time, description, &block)
      EventMachine.add_timer(time) do 
        begin
          yield block
        rescue Exception => e
          Global.logger.error("Error with timer '#{description}': error=#{e} backtrace=#{e.backtrace[0,10]}")
        end
      end
    end
    
    ### IMPORTANT!!!  Do not call from outside of EventMachine
    ### Use queue_command if you need to queue up a command to process
    def on_command(client, cmd)
      @handled = false
      with_error_handling(client, cmd) do
        CommandAliasParser.substitute_aliases(client, cmd)
        Global.plugin_manager.plugins.each do |p|
          with_error_handling(client, cmd) do
            if (p.want_command?(client, cmd))
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

    ### IMPORTANT!!!  Do not call from outside of EventMachine
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
      begin
        yield block
        # Allow plugin exit to bubble up so it shuts the plugin down.
      rescue SystemExit
        raise SystemExit
      rescue Exception => e
        begin
          @handled = true
          Global.logger.error("Error handling command: client=#{client.id} cmd=#{cmd} error=#{e} backtrace=#{e.backtrace[0,10]}")
          client.emit_failure t('dispatcher.error_executing_command', :cmd => cmd.raw, :error_info => e)
        rescue Exception => e2
          Global.logger.error("Error inside of command error handling: error=#{e2} backtrace=#{e2.backtrace[0,10]}")
        end
      end
    end
  end
end