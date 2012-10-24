module AresMUSH
  class Dispatcher

    def initialize(system_manager)
      @system_manager = system_manager
    end
    
    def dispatch(client, cmd)
      begin
         @system_manager.systems.each do |s|
           s.commands.each do |cmd_regex|
              match = /^#{cmd_regex}/.match(cmd)
              if (!match.nil?)
                s.handle(client, match)
              end
           end
         end 
      rescue Exception => e
        # TODO: log
        client.emit "Bad code did badness! #{e}"
      end
    end
  end
end