module AresMUSH    
  module Swrifts
    class EdgeCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swrifts", "edges_lib")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end