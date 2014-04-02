require 'erubis'

module AresMUSH
  module Who
    class WhoCmd
      include AresMUSH::Plugin

      # Validators
      no_args
      no_switches
      
      def initialize
        @renderer =  WhoRenderer.new("who.erb")
      end

      def want_command?(client, cmd)
        cmd.root_is?("who")
      end
      
      def handle        
        client.emit @renderer.render
      end      
    end
  end
end
