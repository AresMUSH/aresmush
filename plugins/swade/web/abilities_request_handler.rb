module AresMUSH
  module Swade
    class AbilitiesRequestHandler
      def handle(request)
        skills = Swade.skills.map { |a| { name: a['name'].titleize, rating: a['rating'] } }
		
        {
          attrs_blurb: Website.format_markdown_for_html(FS3Skills.attr_blurb),
          action_blurb: Website.format_markdown_for_html(FS3Skills.action_blurb),
          background_blurb: Website.format_markdown_for_html(FS3Skills.bg_blurb),
          language_blurb: Website.format_markdown_for_html(FS3Skills.language_blurb),
          advantages_blurb:  Website.format_markdown_for_html(FS3Skills.advantages_blurb),          
         
          skills: skills
		  # Copied from the FS3 stuff.
		  
		  # attrs: attrs,
          # action_skills: action_skills,
          # backgrounds: backgrounds,
          # languages: languages,
          # advantages: advantages,
          # use_advantages: FS3Skills.use_advantages?
        } 
      end
    end
  end
end


