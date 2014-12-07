module AresMUSH
  module Login
    class CharCreatedEvent
      attr_accessor :client
      
      def initialize(client)
        self.client = client
      end
    end
  end
end