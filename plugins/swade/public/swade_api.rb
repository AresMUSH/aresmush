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
	
	def self.returnskillsforweb(char)
		list.to_a.sort_by { |a| a.name }
		.each_with_index
			.map do |a, i| 
			linebreak = i % 3 == 0 ? "\n" : ""
			title = left("#{ a.name }".capitalize, 16,'.')
			rating = left(a.rating, 7)
			"#{linebreak} #{title} #{rating} "
	end	
  end
end