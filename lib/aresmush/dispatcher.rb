module AresMUSH
  class Dispatcher

    def initialize(plugin_manager)
      @plugin_manager = plugin_manager
    end

    def on_command(client, cmd)
      handled = false
      with_error_handling(client, cmd) do
        @plugin_manager.plugins.each do |a|
          if (cmd.logged_in?)
            wants_cmd = a.want_command?(cmd)
          else
            wants_cmd = a.want_anon_command?(cmd)
          end

          if (wants_cmd)
            a.log_command(client, cmd)
            a.on_command(client, cmd)
            handled = true
            break
          end # if
        end # each
        if (!handled)
          logger.info("Unrecognized command: #{cmd}")
          client.emit_ooc t('dispatcher.huh')
        end
      end # with error handling
    end

    def on_event(type, *args)
      begin
        @plugin_manager.plugins.each do |s|
          if (s.respond_to?(:"on_#{type}"))
            s.send(:"on_#{type}", *args)
          end
        end
      rescue Exception => e
        logger.error("Error handling event: event=#{type} error=#{e} backtrace=#{e.backtrace[0,10]}")
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
           handled = true
           logger.error("Error handling command: client=#{client.id} cmd=#{cmd} error=#{e} backtrace=#{e.backtrace[0,10]}")
           client.emit_failure t('dispatcher.error_executing_command', :cmd => cmd.raw, :error_info => e)
        rescue Exception => e2
          logger.error("Error inside of command error handling: error=#{e2} backtrace=#{e2.backtrace[0,10]}")
        end
      end
    end
  end
end