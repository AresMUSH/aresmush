module AresMUSH
  class Dispatcher

    def initialize(addon_manager)
      @addon_manager = addon_manager
    end

    def on_player_command(client, cmd)
      handled = false
      with_cmd_error_handling(client, cmd) do
        @addon_manager.addons.each do |a|
          if (a.respond_to?(:on_player_command))
            a.commands.each do |cmd_key, cmd_regex|
              if (cmd.start_with?(cmd_key))
                cmd_hash = a.crack(client, cmd, cmd_regex)
                handled = a.on_player_command(client, cmd_hash)
              end
              break if handled
            end
          end
          break if handled
        end
      end
      
      if (!handled)
        client.emit_ooc t('dispatcher.huh')
      end
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
    
    def with_cmd_error_handling(client, cmd, &block)
      begin
        logger.debug("Player command: client=#{client.id} cmd=#{cmd.chomp}")
        yield block
      # Allow addon exit to bubble up so it shuts the addon down.
      rescue SystemExit
        raise SystemExit
      rescue Exception => e
        handled = true
        logger.error("Error handling command: client=#{client.id} cmd=#{cmd} error=#{e} backtrace=#{e.backtrace[1,10]}")
        client.emit_failure t('dispatcher.error_executing_command', :cmd => cmd, :error_info => e)
      end
    end
  end
end