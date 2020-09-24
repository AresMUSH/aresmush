module AresMUSH    
  module Swrifts
    class PpowerCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swrifts", "ppower_lib")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end