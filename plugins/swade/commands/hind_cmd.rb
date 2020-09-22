module AresMUSH    
  module Swade
    class HindCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swade", "hinderances_lib")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end