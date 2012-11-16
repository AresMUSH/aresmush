module AresMUSH
  class Dispatcher

    def initialize(addon_manager)
      @addon_manager = addon_manager
    end

    def on_command(client, cmd)
      handled = false
      with_error_handling(client, cmd) do
        @addon_manager.addons.each do |a|
          if (a.want_command?(cmd))
            if (cmd.logged_in?)
              a.on_command(client, cmd)
            else
              a.on_anon_command(client, cmd)
            end
            handled = true
            break
          end # if
        end # each
        if (!handled)
          client.emit_ooc t('dispatcher.huh')
        end
      end # with error handling
    end

    def on_event(type, *args)
      begin
        @addon_manager.addons.each do |s|
          if (s.respond_to?(:"on_#{type}"))
            s.send(:"on_#{type}", *args)
          end
        end
      rescue Exception => e
        logger.error("Error handling event: event=#{type} error=#{e} backtrace=#{e.backtrace[1,10]}")
      end
    end
    
    private
    
    def with_error_handling(client, cmd, &block)
      begin
        logger.debug("Player command: #{client.id} #{cmd}")
        yield block
      # Allow addon exit to bubble up so it shuts the addon down.
      rescue SystemExit
        raise SystemExit
      rescue Exception => e
        handled = true
        logger.error("Error handling command: client=#{client.id} cmd=#{cmd} error=#{e} backtrace=#{e.backtrace[1,10]}")
        client.emit_failure t('dispatcher.error_executing_command', :cmd => cmd.raw, :error_info => e)
      end
    end
  end
end