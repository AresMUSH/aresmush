module AresMUSH    
  module Ffg
    class ArchetypesCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("ffg", "archetypes")
        list = types.sort_by { |a| a['name']}
        template = ArchetypesTemplate.new list
        client.emit template.render
      end
    end
  end
end