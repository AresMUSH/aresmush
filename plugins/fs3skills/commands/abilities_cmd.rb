module AresMUSH

  module FS3Skills
    class AbilitiesCmd
      include CommandHandler
      
      def handle
        
        num_pages = 4
        
        case cmd.page
        when 1
          template = AbilityPageTemplate.new("/attributes.erb", 
              { attrs: FS3Skills.attrs, num_pages: num_pages, page: cmd.page })
        when 2
          template = AbilityPageTemplate.new("/action_skills.erb", 
              { skills: FS3Skills.action_skills, num_pages: num_pages, page: cmd.page })
        when 3
          template = AbilityPageTemplate.new("/background_skills.erb", 
              { skills: FS3Skills.background_skills, num_pages: num_pages, page: cmd.page } )
        when 4
          template = AbilityPageTemplate.new("/languages.erb", 
              { skills: FS3Skills.languages, num_pages: num_pages, page: cmd.page })
        else
          client.emit_failure t('pages.not_that_many_pages')
          return
        end
      
        client.emit template.render
      end
    end
  end
end
