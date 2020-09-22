module AresMUSH    
  module Swade
    class PpowerCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swade", "ppower_lib")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end