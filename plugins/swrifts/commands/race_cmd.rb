module AresMUSH    
  module Swrifts
    class RaceCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swrifts", "race")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end