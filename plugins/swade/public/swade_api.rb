module AresMUSH
  module Swade
    def self.get_abilities_for_web_viewing(char, viewer)
		skills = Website.format_markdown_for_html("Hello World")
        return {

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