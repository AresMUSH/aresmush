module AresMUSH
  class Dispatcher

    def initialize(system_manager)
      @system_manager = system_manager
    end

    def on_player_command(client, cmd)
      handled = false
      begin
        logger.debug("Player command: client=#{client.id} cmd=#{cmd.chomp}")
        @system_manager.systems.each do |s|
          if (s.respond_to?(:on_player_command))
            s.commands.each do |cmd_regex|
              match = /^#{cmd_regex}/.match(cmd)
              if (!match.nil?)
                s.on_player_command(client, match)
                handled = true
              end
            end
          end
        end 
      # Allow system exit to bubble up so it shuts the system down.
      rescue SystemExit
        raise SystemExit
      rescue Exception => e
        handled = true
        logger.error("Error handling command: client=#{client.id} cmd=#{cmd} error=#{e} backtrace=#{e.backtrace[1,10]}")
        client.emit_failure t('dispatcher.error_executing_command', :cmd => cmd, :error_info => e)
      end
      if (!handled)
        client.emit_ooc t('dispatcher.huh')
      end
    end

    def on_event(type, *args)
      begin
        @system_manager.systems.each do |s|
          if (s.respond_to?(:"on_#{type}"))
            s.send(:"on_#{type}", *args)
          end
        end
      rescue Exception => e
        logger.error("Error handling event: event=#{type} error=#{e} args=#{args}")
      end
    end
  end
end