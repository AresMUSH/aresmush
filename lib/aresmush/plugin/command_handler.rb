module AresMUSH
  module CommandHandler
    
    attr_accessor :client, :cmd, :enactor

    def initialize(client, cmd, enactor)
      @client = client
      @cmd = cmd
      @enactor = enactor
    end
    
    # This defines basic processing suitable for many commands.  You can override this 
    # method entirely if you need advanced processing, or just override the helper methods
    # as needed.  See the documentation on crack!, check and handle for more info.
    def on_command
      log_command
      crack!
      
      error = error_check
             
      if (error)
        client.emit_failure(error)
        return
      end
      handle
    end
        
    
    # Override this to perform any advanced argument processing.  For example, if your 
    # command is in the form foo/bar arg1=arg2, you can split up arg1 and arg2 by 
    # doing:
    #    def crack!
    #       @cmd.crack_args!(/(?<arg1>[^\=]+)=(?<arg2>.+)/)
    #       self.arg1 = @cmd.args.arg1
    #       self.arg2 = @cmd.args.arg2
    #    end
    # After that, you will be able to access your command arguments by name by using
    # the attribute accessors self.arg1 and self.arg2
    #
    # Several common regular expressions are defined in ArgParser.rb for your use.
    def crack!
    end

    # This defines basic error checking for commands.  You can 
    # override this method entirely if you want more advanced processing. By default,
    # it will call any methods you define whose names start with 'check_'.
    #
    # Your custom error-checking methods should return 'nil' if everything's ok, otherwise 
    # return an error string (remember to translate!)
    # For example:
    #    def check_foo
    #     return t(your_plugin.some_error_message) if something_is_wrong
    #     return nil
    #   end
    
    def error_check
      # Two universal checks - require login and require args
      if (!client.logged_in? && !allow_without_login)
        return t('dispatcher.must_be_logged_in')
      end
      
      if (required_args)
        required_args[:args].each do |arg|
          return t('dispatcher.invalid_syntax', :command => required_args[:help]) if "#{arg}".strip.length == 0
        end
      end
      
      self.methods.grep(/^check_/).sort.each do |m|
        error = send m
        if (error)
          return error
        end
      end
      return nil
    end
    
    # If you want to automatically check for required arguments, override this method and
    # return a hash with a list of arg variables and a help file to show if one is missing.
    # For example, this will prompt them to see 'help actors' if they forgot the actor name:
    #   def required_args
    #    {
    #      args: [ self.name ],
    #      help: 'actors'
    #    }
    #   end
    def required_args
      nil
    end
    
    # Most commands require you to be connected with a character.  For commands that work from
    # the connect screen, override this method and return true.
    def allow_without_login
      false
    end
    
    # Override this with the details of your command handling.
    def handle
      raise "#{self} didn't actually handle the command!"
    end    
 
    # Override this if you don't want logging at all, or don't want to log the full command - 
    # for instance to avoid logging a connect command for privacy of passwords.
    def log_command
      Global.logger.debug("#{self.class.name}: #{client} Enactor=#{enactor_name} Cmd=#{cmd}")
    end
    
    
    # ---------------------------------------------------------------------------------------------------
    # ---------------------------------------------------------------------------------------------------
    # COMMON UTILITIES
    #
    # These are some common things you'll use in many command handlers.
    # ---------------------------------------------------------------------------------------------------
    # ---------------------------------------------------------------------------------------------------
      
    # The enactor's room, or nil if not logged in.        
    def enactor_room
      @enactor ? @enactor.room : nil
    end
    
    # The enactor's name, or 'anonymous' if not logged in.    
    def enactor_name
      @enactor ? @enactor.name : t('client.anonymous')
    end
    
    # A handy function for stripping off leading and trailing spaces.  Safe to call
    # (returns nil) if 'arg' is nil.
    def trim_input(arg)
      InputFormatter.trim_input(arg)
    end
    
    # A handy function for stripping off leading/trailing spaces and capitalizing
    # its words (like a title).  Safe to call (returns nil) if 'arg' is nil.
    def titleize_input(arg)
      InputFormatter.titleize_input(arg)
    end
  end
end