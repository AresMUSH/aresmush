module AresMUSH
  module Describe
    class RoomTemplate
      include TemplateFormatters
    
      attr_accessor :clients, :exits, :client
            
      def initialize(model, clients, exits, client)
        @model = model
        @clients = clients
        @exits = exits
        @client = client
      end
      
      def name
        @model.name
      end
      
      def description
        @model.description
      end
      
      def ic_time
        ICTime.ictime
      end
      
      def ooc_time
        OOCTime.local_time_str(@client, Time.now)
      end
    end
  end
end