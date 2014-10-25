module AresMUSH
  module ApiCommandHandler
    attr_accessor :game_id, :cmd
      
    def initialize(game_id, cmd)
      @game_id = Integer(game_id)
      @cmd = cmd
      crack!
    end
      
    # Override to set up any custom attributes from the args string
    def crack!
    end
      
    # Override to perform any necessary validation on the command args.
    # Return a string if there's a problem, and nil if everything's ok
    def validate
      nil
    end
    
    module ClassMethods
      # Override if available on master.
      def available_on_master?
        false
      end
    
      # Override if available on a slave game
      def available_on_slave?
        false
      end
      
      # Override with a list of commands this handler handles.
      def commands
        []
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
    
  module ApiResponseHandler
    attr_accessor :client, :response
      
    def initialize(client, response)
      @client = client
      @response = response
      crack!
    end
    
    # Override to set up any custom attributes from the args string
    def crack!
    end
      
    # Override to perform any necessary validation on the command args.
    # Return a string if there's a problem, and nil if everything's ok
    def validate
      nil
    end
    
    module ClassMethods
      # Override if available on master.
      def available_on_master?
        false
      end
    
      # Override if available on a slave game
      def available_on_slave?
        false
      end
      
      # Override with a list of commands this handler handles.
      def commands
        []
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end