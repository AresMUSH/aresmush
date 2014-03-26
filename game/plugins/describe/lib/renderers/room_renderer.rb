module AresMUSH
  module Describe
    class RoomRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room.erb")
      end
      
      def render(model)
        logged_in = Global.client_monitor.logged_in_clients
        clients = logged_in.map { |c| ClientData.new(c) }
        exits = model.exits.map { |e| ExitData.new(e) }
        data = RoomData.new(model, clients, exits)
        @renderer.render(data)
      end
    end
  end
end