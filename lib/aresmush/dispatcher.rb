module AresMUSH
  class Dispatcher

    def initialize(addon_manager)
      @addon_manager = addon_manager
    end

    def on_player_command(client, cmd)
      handled = false
      begin
        logger.debug("Player command: client=#{client.id} cmd=#{cmd.chomp}")
        cmd_root = cmd.split(" ")[0].split("/")[0]

        @addon_manager.addons.each do |a|
          if (a.respond_to?(:on_player_command))
            matched_cmd = a.commands[cmd_root]
            if (matched_cmd.nil?)
               matched_cmd = a.commands[:all]
            end
            if (!matched_cmd.nil?)  
              match = /^#{cmd_root}#{matched_cmd}/.match(cmd)
              a.on_player_command(client, match)
              handled = true
            end
          end
        end 
      # Allow addon exit to bubble up so it shuts the addon down.
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
        @addon_manager.addons.each do |s|
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