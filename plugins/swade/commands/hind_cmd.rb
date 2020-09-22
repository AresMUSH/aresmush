module AresMUSH    
  module Swade
    class HindCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swade", "hinderances")
        list = types.sort_by { |a| a['name']}
        template = HinderancesTemplate.new list
        client.emit template.render
      end
    end
  end
end