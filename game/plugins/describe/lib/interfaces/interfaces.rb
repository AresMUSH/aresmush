module AresMUSH
  module Describe
    def self.get_desc(model)     
      if (model.class == Room)

        logged_in = Global.client_monitor.logged_in_clients
        clients = logged_in.map { |c| ClientData.new(c) }
        exits = model.exits.map { |e| ExitData.new(e) }
        data = RoomData.new(model, clients, exits)
        return RendererFactory.room_renderer.render(data)
      elsif (model.class == Character)
        client = Global.client_monitor.find_client(model)
        if (client.nil?)
          return t('db.object_not_found')
        end
        data = ClientData.new(client)
        return RendererFactory.char_renderer.render(data)
      elsif (model.class == Exit)
        data = ExitData.new(model)
        return RendererFactory.exit_renderer.render(data)
      else
        raise "Invalid model type: #{model}"
      end
    end
  end
end
