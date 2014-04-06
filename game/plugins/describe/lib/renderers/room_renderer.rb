module AresMUSH
  module Describe
    class RoomRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/room.erb")
      end
      
      def render(model)
        logged_in = Global.client_monitor.logged_in_clients.select { |c| c.room == model }
        clients = logged_in.map { |c| ClientTemplate.new(c) }
        exits = model.exits.map { |e| ExitTemplate.new(e) }
        data = RoomTemplate.new(model, clients, exits)
        @renderer.render(data)
      end
    end
  end
end