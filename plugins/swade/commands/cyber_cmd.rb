module AresMUSH    
  module Swrifts
    class CyberCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swrifts", "cyber_lib")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end