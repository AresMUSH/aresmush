module AresMUSH    
  module Ffg
    class SkillsCmd
      include CommandHandler
  
      def handle
        skills = Global.read_config("ffg", "skills")
        list = skills.sort_by { |a| a['name']}
                  .map { |a| "%xh#{a['name'].ljust(15)}%xn #{a['description']} (#{a['characteristic']})"}
                    
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('ffg.skills_title')
        client.emit template.render
      end
    end
  end
end