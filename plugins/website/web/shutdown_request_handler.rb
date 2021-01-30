module AresMUSH
  module Website
    class ShutdownRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
       
        Global.notifier.notify_ooc(:shutdown, t('manage.shutdown', :name => enactor.name)) do |char|
          true
        end
        
        # Don't use dispatcher here because we want a hard kill
        EventMachine.add_timer(5) do
          EventMachine.stop_event_loop
          
          path = File.join( AresMUSH.root_path, "bin", "killares" )
          `#{path}`
          
          raise SystemExit.new
        end
        
        
        {}
      end
    end
  end
end