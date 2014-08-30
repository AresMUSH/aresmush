module AresMUSH
  module Describe
    class RoomTemplate
      include TemplateFormatters
    
      attr_accessor :clients, :exits, :client
            
      def initialize(model, clients, exits, client)
        @model = model
        @clients = clients
        @exits = exits.sort_by { |e| e.name }
        @client = client
      end
      
      def name
        left(@model.name, 40)
      end
      
      def description
        @model.description
      end
      
      def ic_time
        ICTime.month_str
      end
      
      def area
        right(@model.area, 37)
      end
      
      def grid
        "(#{@model.grid_x},#{@model.grid_y})"
      end
      
      def ooc_time
        OOCTime.local_time_str(@client, Time.now)
      end
    end
  end
end