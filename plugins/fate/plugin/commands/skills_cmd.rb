module AresMUSH    
  module Fate
    class SkillsCmd
      include CommandHandler
  
      def handle
        skills = Global.read_config("fate", "skills")
        list = skills.sort_by { |a| a['name']}
                  .map { |a| "%xh#{a['name'].ljust(15)}%xn #{a['description']}"}
                    
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('fate.skills_title')
        client.emit template.render
      end
    end
  end
end