module AresMUSH
  module Plugin
    def initialize(container)
      @container = container
      after_initialize
    end
    
    attr_reader :container
        
    # Override this with any custom initialization
    def after_initialize
    end
    
    # Override this with the processing needed to tell if you want a particular command.
    #
    # You can do basic operations:
    #    cmd.raw.start_with?(":")
    #
    # Or use some of the handy helper methods:
    #    cmd.root_is?("finger")
    #    cmd.logged_in?
    #
    # You can even do more complex and/or combinations.
    def want_command?(cmd)
      false
    end
    
    # Override this with the details of your command handling when a player is logged in.  
    # See the Command class for a whole bunch of useful fields you can access.
    def on_command(client, cmd)
      logger.warn("#{self} said it wanted a command and didn't handle it!")
    end
    
    # Override this with the details of your command handling when a player is sitting at the login screen.
    # See the Command class for a whole bunch of useful fields you can access.
    def on_anon_command(client, cmd)
      logger.debug("#{self} ignored an anonymous command.")
    end   
    
  end
end