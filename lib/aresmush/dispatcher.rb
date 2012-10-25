module AresMUSH
  class Dispatcher

    def initialize(system_manager)
      @system_manager = system_manager
    end
    
    def dispatch(client, cmd)
      handled = false
      begin
         @system_manager.systems.each do |s|
           s.commands.each do |cmd_regex|
              match = /^#{cmd_regex}/.match(cmd)
              if (!match.nil?)
                s.handle(client, match)
                handled = true
              end
           end
         end 
      rescue Exception => e
        # TODO: log
        client.emit_failure "Bad code did badness! #{e}"
      end
      if (!handled)
        client.emit_ooc t('huh')
      end
    end
  end
end