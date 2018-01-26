module AresMUSH
  module Website
    class ShutdownRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
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