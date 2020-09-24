module AresMUSH    
  module Swrifts
    class FandgCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swrifts", "fandg")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end