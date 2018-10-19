module AresMUSH    
  module Ffg
    class CareersCmd
      include CommandHandler
  
      def handle
        careers = Global.read_config("ffg", "careers")
        
        template = CareersTemplate.new careers
        client.emit template.render
      end
    end
  end
end