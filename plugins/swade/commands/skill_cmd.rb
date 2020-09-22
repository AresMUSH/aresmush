module AresMUSH    
  module Swade
    class SkillCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swade", "skill")
        list = types.sort_by { |a| a['name']}
        template = IconicfTemplate.new list
        client.emit template.render
      end
    end
  end
end