module AresMUSH
  module Commands
    class Quit
      def initialize(container)
      end

      def commands
        ["quit"]
      end
      
      def handle(client, cmd)
        client.disconnect
      end
    end
  end
end
