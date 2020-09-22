module AresMUSH    
  module Swade
    class StatsCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swade", "stats_lib")
        list = types.sort_by { |a| a['name']}
        template = StatsTemplate.new list
        client.emit template.render
      end
    end
  end
end