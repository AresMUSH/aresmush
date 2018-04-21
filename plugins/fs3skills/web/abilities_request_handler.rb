module AresMUSH
  module FS3Skills
    class AbilitiesRequestHandler
      def handle(request)
        attrs = FS3Skills.attrs.map { |a| { name: a['name'].titleize, description: a['desc'] } }
        backgrounds = FS3Skills.background_skills.map { |name, desc| { name: name, description: desc } }
        action_skills = FS3Skills.action_skills.map { |a| {
          name: a['name'].titleize,
          linked_attr: a['linked_attr'],
          description: a['desc'],
          specialties: a['specialties'] ? a['specialties'].join(', ') : nil,
        }}
        languages = FS3Skills.languages.map { |a| { name: a['name'], description: a['desc'] } }
        
        {
          attrs_blurb: WebHelpers.format_markdown_for_html(FS3Skills.attr_blurb),
          action_blurb: WebHelpers.format_markdown_for_html(FS3Skills.action_blurb),
          background_blurb: WebHelpers.format_markdown_for_html(FS3Skills.bg_blurb),
          language_blurb: WebHelpers.format_markdown_for_html(FS3Skills.language_blurb),
          
          attrs: attrs,
          action_skills: action_skills,
          backgrounds: backgrounds,
          languages: languages
        } 
      end
    end
  end
end


