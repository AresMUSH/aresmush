module AresMUSH
  module Plugin
    
    attr_accessor :client, :cmd
        
    # Override this with the processing needed to tell if you want a particular command
    # Commonly, you'll look at the root and the switch:
    #    cmd.root_is?("mail") && cmd.switch_is?("new")
    def want_command?(client, cmd)
      false
    end

    # This defines basic processing suitable for many commands.  You can override this 
    # method entirely if you need advanced processing, or just override the helper methods
    # as needed.  See the documentation on crack!, check and handle for more info.
    def on_command(client, cmd)
      @client = client
      @cmd = cmd
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
    # Several common regular expressions are defined in CommonCracks.rb for your use.
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
    # 
    # Several common error checking methods are defined, and you can include them
    # in your plugin just by including them in your plugin file.
    # For example:
    #       include PluginRequiresLogin
    def error_check
      self.methods.grep(/^check_/).sort.each do |m|
        error = send m
        if (!error.nil?)
          return error
        end
      end
      return nil
    end
    
    # Override this with the details of your command handling.
    def handle
      Global.logger.warn("#{self} said it wanted a command and didn't handle it!")
    end    
 
    # Override this if you don't want logging at all, or don't want to log the full command - 
    # for instance to avoid logging a connect command for privacy of passwords.
    def log_command
      Global.logger.debug("#{self.class.name}: #{client} Cmd=#{cmd}")
    end
    
    # A handy function for stripping off leading and trailing spaces.  Safe to call
    # even if 'arg' is nil.
    def trim_input(arg)
      return nil if arg.nil?
      return arg.strip
    end
    
    # A handy function for stripping off leading/trailing spaces and capitalizing
    # its words (like a title).  Safe to call even if 'arg' is nil.
    def titleize_input(arg)
      return nil if arg.nil?
      return arg.strip.titleize
    end
  end
end