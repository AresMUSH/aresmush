module AresMUSH    
  module Swade
    class SkillCmd
      include CommandHandler
  
      def handle
        types = Global.read_config("swade", "skills")
        list = types.sort_by { |a| a['name']}
        template = SkillsTemplate.new list
        client.emit template.render
      end
    end
  end
end