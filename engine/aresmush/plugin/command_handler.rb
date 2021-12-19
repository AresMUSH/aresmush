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
    # as needed.  See the documentation on parse_args, check and handle for more info.
    def on_command
      log_command
      parse_args
      
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
    #    def parse_args
    #       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
    #       self.arg1 = args.arg1
    #       self.arg2 = args.arg2
    #    end
    # A variety of common parsing strings are defined in ArgParser, and you can make your own.
    def parse_args
    end

    # This defines basic error checking for commands.  You can 
    # override this method entirely if you want more advanced processing. By default,
    # it will call any methods you define whose names start with 'check_'.
    #
    # Your custom error-checking methods should return 'nil' if everything's ok, otherwise 
    # return an error string (remember to translate!)
    # For example:
    #    def check_foo
    #     return t('your_plugin.some_error_message') if something_is_wrong
    #     return nil
    #   end
    
    def error_check
      # Two universal checks - require login and require args
      if (!client.logged_in? && !allow_without_login)
        return t('dispatcher.must_be_logged_in')
      end
      
      if (required_args)
        required_args.each do |arg|
          
          if "#{arg}".strip.length == 0            
            return t('dispatcher.invalid_syntax', :cmd => @cmd.root_plus_switch) 
          end
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
    
    # Strips leading and trailing spaces from an arg.  Returns nil if 'arg' is nil.
    def trim_arg(arg)
      InputFormatter.trim_arg(arg)
    end
    
    # Removes leading/trailing spaces from and arg and capitalizes its words (like a title)
    # Returns nil if 'arg' is nil.
    def titlecase_arg(arg)
      InputFormatter.titlecase_arg(arg)
    end
    
    # Converts an arg to all-uppercase and removes leading/trailing spaces.  Returns nil if 'arg' is nil
    def upcase_arg(arg)
      arg ? trim_arg(arg.upcase) : nil
    end
    
    # Converts an arg to all-lowercase and removes leading/trailing spaces.  Returns nil if 'arg' is nil
    def downcase_arg(arg)
      arg ? trim_arg(arg.downcase) : nil
    end
    
    # Converts an arg to an integer.  Returns nil if 'arg' is nil
    def integer_arg(arg)
      arg ? trim_arg(arg).to_i : nil
    end
    
    # Splits an argument into an array.  Returns nil if 'arg' is nil.  By default, splits at
    # spaces but you can pass something else (like to split at a comma)
    def list_arg(arg, split = " ")
      arg ? arg.split(split) : nil
    end
    
    # Splits an argument into an array and trims each item in the list.  Returns nil if 'arg' is nil.  
    # By default, splits at spaces but you can pass something else (like to split at a comma)
    def trimmed_list_arg(arg, split = " ")
      arg ? arg.split(split).map { |a| trim_arg(a) } : nil
    end

    # Splits an argument into an array and trims//help/s each item in the list.  Returns nil if 'arg' is nil.  
    # By default, splits at spaces but you can pass something else (like to split at a comma)
    def titlecase_list_arg(arg, split = " ")
      arg ? arg.split(split).map { |a| titlecase_arg(a) }.select { |a| !a.blank? } : nil
    end
  end
end