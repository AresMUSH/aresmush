module AresMUSH
  module Swade
    def self.get_abilities_for_web_viewing(char, viewer)
		#skills = Website.format_markdown_for_html(char.swade_skills)
		skills = returnskillsforweb(char.swade_skills)
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
	
	def self.returnskillsforweb(skills)
		skills.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
			linebreak = i % 3 == 0 ? " --- " : ""
			title = "#{ a.name }".capitalize
			rating = a.rating
			"#{linebreak} #{title} #{rating} "
		end
	end	
  end
end